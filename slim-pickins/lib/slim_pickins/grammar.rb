# frozen_string_literal: true

require "temple"
require_relative "word"

module SlimPickins
  # Turns spoken vocabulary into a helper call, while the template compiles.
  #
  # Slim reads `navigation Abide` as a tag with inline text. Because it has
  # inline text, the indented lines below it arrive as *continuation of that
  # text* rather than as child tags -- the parser hands us "Abide",
  # "\nDashboard", "\nAccounts" and stops interpreting. That is the whole
  # reason this grammar can exist: the block beneath a word is ours to read,
  # not Slim's, so a word may define what its own children mean.
  #
  # It also sets the shape of the language. Giving a word a subject is exactly
  # what stops Slim parsing the block, so a word is written one of two ways:
  #
  #   navigation Abide        with a subject: the lines below are free text,
  #       Dashboard           so an item may be any phrase.
  #
  #   accounts                without one: the lines below are parsed, so an
  #       Name                item is a single name -- but the parser has
  #       Balance             read it, and it could carry more later.
  #
  # Both arrive as a subject and a list of item names. Which form a word
  # wants is the word's business; the template just writes what reads best.
  #
  # The rewrite happens once, at compile time, in process. No build step.
  #
  #   navigation Abide          [:html, :tag, "navigation", ...]
  #       Dashboard        =>   [:dynamic, 'sp_speak("navigation", "Abide",
  #       Accounts                            ["Dashboard", "Accounts"])']
  #
  # Text is emitted as a Ruby double-quoted literal, so #{...} in a template
  # still interpolates in the view's scope.
  class Grammar < ::Temple::Filter
    def on_html_tag(name, attrs, content = nil)
      return passthrough(name, attrs, content) unless Word.vocabulary.key?(name.to_s)

      subject, items = spoken(content)
      [:dynamic, %{sp_speak(#{quote(name)}, #{quote(subject)}, [#{items.map { |i| quote(i) }.join(", ")}])}]
    end

    # Temple's dispatcher walks the node types it already knows, which does not
    # include Slim's own. Without these two, a word is found in plain markup
    # but not inside `= ui_card do` or `- if`, where most of a view lives.
    def on_slim_output(escape, code, content) = [:slim, :output, escape, code, compile(content)]
    def on_slim_control(code, content) = [:slim, :control, code, compile(content)]

    private

    # Parsed children mean the word was given no subject; text means it was.
    def spoken(content)
      children = elements(content)
      return ["", children.map { |child| label(child) }] if children.any?

      subject, *items = lines(content)
      [subject.to_s, items]
    end

    # Direct child tags only. Descent stops at a tag, so an item's own
    # children stay its own business rather than becoming further items.
    def elements(node)
      return [] unless node.is_a?(Array)
      return [node] if node[0] == :html && node[1] == :tag

      node.flat_map { |child| elements(child) }
    end

    # An item's name, plus any words trailing it on the same line.
    def label(element)
      name, content = element[2].to_s, element[4]

      unless elements(content).empty?
        raise ArgumentError, "the item #{name.inspect} has children, which no word can read yet"
      end

      [name, *lines(content)].join(" ")
    end

    def passthrough(name, attrs, content)
      return [:html, :tag, name, compile(attrs)] unless content

      [:html, :tag, name, compile(attrs), compile(content)]
    end

    # The word's own line, then one per indented line beneath it. Blank lines
    # are how a long list is grouped for the eye, so they carry no meaning.
    def lines(content)
      text(content).split("\n").map(&:strip).reject(&:empty?)
    end

    def text(node)
      return "" unless node.is_a?(Array)
      return node[2].to_s if node[0] == :slim && node[1] == :interpolate
      return node[1].to_s if node[0] == :static

      node.map { |child| text(child) }.join
    end

    def quote(text) = %("#{text.to_s.gsub(/[\\"]/) { |char| "\\#{char}" }}")
  end
end
