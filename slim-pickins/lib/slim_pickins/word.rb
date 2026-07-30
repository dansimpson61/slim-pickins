# frozen_string_literal: true

require_relative "rendering"

module SlimPickins
  # A word is a component you speak instead of call.
  #
  #   navigation Abide
  #       Dashboard
  #       Accounts
  #       Portfolios
  #
  # No sigil, no prefix, no quotes, no commas. The line names a thing in the
  # application's own terms; everything else -- the tags, the classes, the
  # hrefs, the active state -- is the word's business and never the caller's.
  #
  # A word takes exactly two things:
  #
  #   subject  what follows the word on its own line: the one thing that makes
  #            this instance itself. `Abide` is the site, not a setting.
  #   items    the indented lines beneath it, as plain strings. They mean
  #            whatever this word says they mean. Under `navigation` they are
  #            destinations; under some other word they would be something
  #            else entirely. Nothing generic happens to them.
  #
  # Declare one by subclassing and writing `render`:
  #
  #   class Navigation < SlimPickins::Word
  #     def render = tag(:nav, ...)
  #   end
  #
  # The spoken name is derived from the class name, so it is written once.
  # Vocabulary is open: an application declares the words it needs, and the
  # grammar picks them up with no registration list to keep in agreement.
  class Word
    include Rendering

    class << self
      # Spoken name => class. Consulted by Grammar when compiling a template,
      # and by sp_speak when rendering one.
      def vocabulary = @vocabulary ||= {}

      def inherited(subclass)
        super
        Word.vocabulary[subclass.spoken] = subclass
      end

      # Derived from the class name. Declare it explicitly only to speak a
      # name the class cannot spell -- `spoken "nav"` for class Navigation.
      def spoken(explicit = nil)
        @spoken = explicit.to_s if explicit
        @spoken ||= name.split("::").last
                        .gsub(/([a-z\d])([A-Z])/, '\1-\2')
                        .downcase
      end
    end

    def initialize(subject, items)
      @subject = subject
      @items = items
    end

    private

    attr_reader :subject, :items
  end
end
