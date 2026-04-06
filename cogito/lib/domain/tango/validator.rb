module Tango
  class Validator
    def initialize(grid)
      @grid = grid
    end

    def valid?
      return false unless constraints_met?
      return false unless no_three_in_a_row_or_col?
      return false unless balanced_rows_and_cols?
      true
    end
    
    def complete_and_valid?
      @grid.filled? && valid?
    end

    private

    def constraints_met?
      @grid.constraints.each do |rule|
        c1 = @grid.cell_at(*rule[:cells][0])
        c2 = @grid.cell_at(*rule[:cells][1])
        next if c1.empty? || c2.empty?

        if rule[:type] == :same && c1.value != c2.value
          return false
        elsif rule[:type] == :different && c1.value == c2.value
          return false
        end
      end
      true
    end

    def no_three_in_a_row_or_col?
      # Check rows
      @grid.size.times do |r|
        row = @grid.row(r)
        return false if has_three_identical?(row)
      end

      # Check cols
      @grid.size.times do |c|
        col = @grid.col(c)
        return false if has_three_identical?(col)
      end

      true
    end

    def has_three_identical?(cells)
      values = cells.map(&:value)
      values.each_cons(3) do |a, b, c|
        return true if a != :empty && a == b && b == c
      end
      false
    end

    def balanced_rows_and_cols?
      half = @grid.size / 2

      @grid.size.times do |r|
        row = @grid.row(r)
        suns = row.count(&:sun?)
        moons = row.count(&:moon?)
        return false if suns > half || moons > half
      end

      @grid.size.times do |c|
        col = @grid.col(c)
        suns = col.count(&:sun?)
        moons = col.count(&:moon?)
        return false if suns > half || moons > half
      end

      true
    end
  end
end
