module Queens
  class Validator
    def initialize(grid)
      @grid = grid
    end

    def complete_and_valid?
      @grid.queens.size == @grid.size && valid?
    end

    def valid_placement?
      return false unless valid_rows?
      return false unless valid_cols?
      return false unless valid_adjacency?
      true
    end

    def valid?
      return false unless valid_placement?
      return false unless valid_regions?
      true
    end

    private

    def valid_rows?
      @grid.size.times do |r|
        queens_count = @grid.row(r).count(&:has_queen)
        return false if queens_count > 1
      end
      true
    end

    def valid_cols?
      @grid.size.times do |c|
        queens_count = @grid.col(c).count(&:has_queen)
        return false if queens_count > 1
      end
      true
    end

    def valid_regions?
      @grid.regions.each do |region_cells|
        queens_count = region_cells.count(&:has_queen)
        return false if queens_count > 1
      end
      true
    end

    def valid_adjacency?
      queens = @grid.queens
      queens.each do |q1|
        queens.each do |q2|
          next if q1 == q2
          # Check Chebyshev distance for any adjacency including diagonal
          if (q1.row - q2.row).abs <= 1 && (q1.col - q2.col).abs <= 1
            return false
          end
        end
      end
      true
    end
  end
end
