require_relative 'cell'

module Tango
  class Grid
    attr_reader :size, :cells, :constraints

    # constraints look like: { type: :same, cells: [[0, 0], [0, 1]] }
    def initialize(size: 6, initial_state: [], constraints: [])
      @size = size
      @cells = Array.new(size) do |row|
        Array.new(size) do |col|
          value = initial_state.dig(row, col) || :empty
          Cell.new(row, col, value: value)
        end
      end
      @constraints = constraints
    end

    def cell_at(row, col)
      return nil unless row.between?(0, size - 1) && col.between?(0, size - 1)
      @cells[row][col]
    end

    def row(index)
      @cells[index]
    end

    def col(index)
      @cells.map { |row| row[index] }
    end

    def set_cell(row, col, value)
      cell = cell_at(row, col)
      cell.value = value if cell
    end
    
    def filled?
      @cells.flatten.none?(&:empty?)
    end
  end
end
