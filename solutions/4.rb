require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day4 < Base
  include Grid::Matrix
  DAY = 4

  def initialize(type = "example")
    init_grid(Parser.lines(DAY, type))
    @map = {}
    (0..@max_x).each do |x|
      (0..@max_y).each do |y|
        if @grid[x][y] == "@"
          @map[[x, y]] = []
          ALL_DIRS.each do |dx, dy|
            nx, ny = [x + dx, y + dy]
            @map[[x, y]] << [nx, ny] if @grid[nx][ny] == "@"
          end
        end
      end
    end
  end

  def one
    @map.values.count { |n| n.length < 4 }
  end

  def two
    candidates = @map.select { |k, v| v.length < 4 }
    count = 0
    while candidates.keys.length > 0
      new_candidates = {}
      candidates.keys.each do |roll|
        next unless @map[roll]
        @map[roll].each do |n|
          @map[n].delete(roll)
          new_candidates[n] = true if @map[n].length < 4
        end
        @map.delete(roll)
        count += 1
      end
      candidates = new_candidates
    end
    count
  end
end
