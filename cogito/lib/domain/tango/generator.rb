require_relative 'grid'
require_relative 'validator'

module Tango
  class Generator
    def initialize(seed: nil)
      @random = seed ? Random.new(seed) : Random.new
    end

    def generate(size: 6)
      grid = Grid.new(size: size)
      solve(grid)
      
      # Now grid is a fully solved valid grid.
      # Let's extract some constraints.
      constraints = []
      
      # We just randomly pick adjacent pairs and record their relationship
      # until we have a good number of clues. Let's aim for ~ (size * size) / 3 constraints.
      target_constraints = (size * size) / 3
      pairs = []
      
      size.times do |r|
        size.times do |c|
          pairs << [[r, c], [r, c + 1]] if c + 1 < size
          pairs << [[r, c], [r + 1, c]] if r + 1 < size
        end
      end
      
      selected_pairs = pairs.sample(target_constraints, random: @random)
      selected_pairs.each do |p1, p2|
        v1 = grid.cell_at(*p1).value
        v2 = grid.cell_at(*p2).value
        type = (v1 == v2) ? :same : :different
        constraints << { type: type, cells: [p1, p2] }
      end
      
      # Prepare the puzzle by creating an empty state with constraints
      puzzle_state = Array.new(size) { Array.new(size, :empty) }
      
      # Keep some percentage of cells as hints
      hints_count = (size * size) / 5
      hints = []
      size.times { |r| size.times { |c| hints << [r, c] } }
      hints.sample(hints_count, random: @random).each do |r, c|
        puzzle_state[r][c] = grid.cell_at(r, c).value
      end

      # Return a puzzle: an grid with hints and constraints.
      Grid.new(size: size, initial_state: puzzle_state, constraints: constraints)
    end

    private

    def solve(grid, row = 0, col = 0)
      if col == grid.size
        col = 0
        row += 1
      end

      return true if row == grid.size

      %i[sun moon].shuffle(random: @random).each do |val|
        grid.set_cell(row, col, val)
        if Validator.new(grid).valid?
          return true if solve(grid, row, col + 1)
        end
        grid.set_cell(row, col, :empty)
      end

      false
    end
  end
end
