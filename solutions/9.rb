require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day9 < Base
  DAY = 9

  def initialize(type = "example")
    @tiles = Parser.lines(DAY, type).map do |line|
      line.split(",").map(&:to_i)
    end
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
    max = 0
    @tiles.combination(2).each do |(x1, y1), (x2, y2)|
      next if @tiles.any? do |x,y|
        x > [x1, x2].min && x < [x1, x2].max && y > [y1, y2].min && y < [y1, y2].max
      end

      area = ((x1 - x2).abs + 1) * ((y1 - y2).abs + 1)
      #puts "#{x1},#{y1} -  #{x2},#{y2}  (#{area})"
      max = area if area > max
    end
    max
  end
end
