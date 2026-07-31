# frozen_string_literal: true

require_relative "word"

module SlimPickins
  # A word whose name is a model, in the plural.
  #
  #   accounts
  #       Name
  #       Type
  #       Balance
  #       Actions
  #
  # The name is the only argument such a word needs. It says which collection
  # the route prepared, and where each member lives -- so a view names a list
  # without repeating the model in an ivar, a path, and a controller value.
  #
  # Items name the **aspects** of a member that this list shows. A table
  # renders an aspect as a column and a grid of cards renders it as a region;
  # which of those happens is the word's business, and the view does not say.
  class Collection < Word
    abstract

    class << self
      # Which method draws which aspect, declared once:
      #
      #   renders "Name"    => :editable_name,
      #           "Balance" => :balance
      #
      # The view chooses which of them appear, and in what order. An aspect is
      # not a key into the data -- `Balance` may well be a question for a
      # ledger -- so the word says what it means by each.
      def renders(map) = parts.merge!(map.transform_keys(&:to_s))

      def parts = @parts ||= {}
    end

    private

    # One aspect of one member. Asking for an aspect the word does not have
    # names the ones it does, since the view was written by hand.
    def part(aspect, member)
      renderer = self.class.parts.fetch(aspect) do
        raise ArgumentError,
              "#{self.class.spoken} has no #{aspect.inspect}; " \
              "try #{self.class.parts.keys.join(', ')}"
      end

      send(renderer, member)
    end

    # What the route prepared, found by the name the view spoke. This is the
    # convention doing its job: `accounts` means @accounts, and a word that
    # had to be told would not be worth the name.
    def members = view.instance_variable_get("@#{self.class.spoken}") || []

    def empty? = members.empty?

    # Where the model lives, and where one member lives.
    def path = "/#{self.class.spoken}"
    def path_for(member) = "#{path}/#{member['id']}"

    # The aspects this list was asked for, in the order it asked.
    alias aspects items
  end
end
