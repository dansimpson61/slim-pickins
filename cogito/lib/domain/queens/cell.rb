module Queens
  class Cell
    attr_reader :row, :col
    attr_accessor :region_id, :has_queen

    def initialize(row, col, region_id: 0, has_queen: false)
      @row = row
      @col = col
      @region_id = region_id
      @has_queen = has_queen
    end

    def toggle_queen!
      @has_queen = !@has_queen
    end
  end
end
