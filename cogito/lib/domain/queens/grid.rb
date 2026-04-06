require_relative 'cell'

module Queens
  class Grid
    attr_reader :size, :cells

    def initialize(size: 8, region_map: nil)
      @size = size
      @cells = Array.new(size) do |row|
        Array.new(size) do |col|
          r_id = region_map ? region_map[row][col] : 0
          Cell.new(row, col, region_id: r_id)
        end
      end
    end

    def cell_at(row, col)
      return nil unless row.between?(0, size - 1) && col.between?(0, size - 1)
      @cells[row][col]
    end

    def row(index)
      @cells[index]
    end

    def col(index)
      @cells.map { |r| r[index] }
    end

    def regions
      @cells.flatten.group_by(&:region_id).values
    end
    
    def queens
      @cells.flatten.select(&:has_queen)
    end
  end
end
