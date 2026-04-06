require_relative 'grid'
require_relative 'validator'

module Queens
  class Generator
    def initialize(seed: nil)
      @random = seed ? Random.new(seed) : Random.new
    end

    def generate(size: 8)
      grid = Grid.new(size: size)
      solve_queens(grid)
      
      region_map = generate_regions(grid)
      
      # Return a new grid with the region map and no queens placed
      Grid.new(size: size, region_map: region_map)
    end

    private

    def solve_queens(grid, row = 0)
      return true if row == grid.size

      cols = (0...grid.size).to_a.shuffle(random: @random)
      cols.each do |col|
        cell = grid.cell_at(row, col)
        cell.has_queen = true
        
        if Validator.new(grid).valid_placement?
          return true if solve_queens(grid, row + 1)
        end
        
        cell.has_queen = false
      end

      false
    end

    def generate_regions(grid)
      map = Array.new(grid.size) { Array.new(grid.size, nil) }
      queens = grid.queens
      
      frontiers = []
      
      queens.each_with_index do |q, index|
        region_id = index + 1
        map[q.row][q.col] = region_id
        add_neighbors(q.row, q.col, grid.size, map, region_id, frontiers)
      end
      
      until frontiers.empty?
        idx = @random.rand(frontiers.size)
        candidate = frontiers.delete_at(idx)
        r, c, region_id = candidate
        
        if map[r][c].nil?
          map[r][c] = region_id
          add_neighbors(r, c, grid.size, map, region_id, frontiers)
        end
      end
      
      map
    end
    
    def add_neighbors(r, c, size, map, region_id, frontiers)
      directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
      directions.shuffle(random: @random).each do |dr, dc|
        nr, nc = r + dr, c + dc
        if nr >= 0 && nr < size && nc >= 0 && nc < size && map[nr][nc].nil?
          frontiers << [nr, nc, region_id]
        end
      end
    end
  end
end
