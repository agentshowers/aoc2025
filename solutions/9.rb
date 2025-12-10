require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day9 < Base
  DAY = 9
  LEFT = -1
  RIGHT = 1
  UP = -1
  DOWN = 1
  NEXT_INSIDE = {
    [LEFT, UP, UP]      => RIGHT,
    [LEFT, UP, DOWN]    => LEFT,
    [LEFT, DOWN, UP]    => LEFT,
    [LEFT, DOWN, DOWN]  => RIGHT,
    [RIGHT, UP, UP]     => LEFT,
    [RIGHT, UP, DOWN]   => RIGHT,
    [RIGHT, DOWN, UP]   => RIGHT,
    [RIGHT, DOWN, DOWN] => LEFT,
  }.freeze

  def initialize(type = "example")
    @tiles = Parser.lines(DAY, type).map do |line|
      line.split(",").map(&:to_i)
    end.sort_by { |t| [t[0], t[1]] }
  end

  def one
    max = 0
    @tiles.combination(2).each do |(x1, y1), (x2, y2)|
      area = ((x1 - x2).abs + 1) * ((y1 - y2).abs + 1)
      max = area if area > max
    end
    max
  end

  def two
    calc_limits

    max = 0
    @tiles.combination(2).each do |(x1, y1), (x2, y2)|
      area = ((x1 - x2).abs + 1) * ((y1 - y2).abs + 1)
      next if area <= max
      next unless validate(@limits_y[y1], x1, x2)
      next unless validate(@limits_y[y2], x1, x2)
      ya, yb = [y1, y2].sort
      next unless validate(@limits_x[x1], ya, yb)
      next unless validate(@limits_x[x2], ya, yb)

      max = area
    end

    max
  end

  def calc_limits
    @limits_x = Hash.new { |h, k| h[k] = [] }
    @limits_y = Hash.new { |h, k| h[k] = [] }

    x, y = @tiles.first
    visits = 0
    axis = 1
    inside = DOWN
    dir = LEFT
    while visits < @tiles.length
      if axis == 1
        next_x, next_y = @tiles.find { |a, b| a == x && b != y }
        dy = (next_y - y) <=> 0
        if dy == inside
          @limits_y[y] << x
          @limits_x[x] << y
        end
        loop do
          y += dy
          break if y == next_y
          @limits_y[y] << x
        end
        inside = NEXT_INSIDE[[dir, inside, dy]]
        dir = dy
      else
        next_x, next_y = @tiles.find { |a, b| a != x && b == y }
        dx = (next_x - x) <=> 0
        if dx == inside
          @limits_y[y] << x
          @limits_x[x] << y
        end
        loop do
          x += dx
          break if x == next_x
          @limits_x[x] << y
        end
        inside = NEXT_INSIDE[[dir, inside, dx]]
        dir = dx
      end
      axis = 1 - axis
      visits += 1
    end

    @limits_x.values.map(&:sort!)
    @limits_y.values.map(&:sort!)
  end

  def validate(arr, l, h)
    idx_l = arr.rindex { |x| x <= l }
    idx_h = arr.find_index { |x| x >= h }
    idx_l && idx_h && (idx_h - idx_l <= 1)
  end

end
