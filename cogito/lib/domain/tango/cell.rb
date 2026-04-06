module Tango
  class Cell
    attr_reader :row, :col
    attr_accessor :value # :empty, :sun, :moon

    def initialize(row, col, value: :empty)
      @row = row
      @col = col
      @value = value
    end

    def sun?
      @value == :sun
    end

    def moon?
      @value == :moon
    end

    def empty?
      @value == :empty
    end

    def toggle!
      @value = case @value
               when :empty then :sun
               when :sun then :moon
               when :moon then :empty
               end
    end
  end
end
