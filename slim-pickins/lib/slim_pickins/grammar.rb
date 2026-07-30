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
  # It also fixes the one hard limit. A word takes an argument *or* has
  # structured children, never both, because supplying the argument is exactly
  # what makes Slim stop parsing the block. Items are therefore plain lines.
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

      subject, *items = lines(content)
      [:dynamic, %{sp_speak(#{quote(name)}, #{quote(subject)}, [#{items.map { |i| quote(i) }.join(", ")}])}]
    end

    private

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
