require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day7 < Base
  DAY = 7

  def initialize(type = "example")
    lines = Parser.lines(DAY, type).map(&:chars)
    @beams = { lines[0].find_index("S") => 1 }
    @splits = 0
    lines[1..].each do |line|
      new_beams = Hash.new(0)
      @beams.each do |idx, count|
        if line[idx] == "."
          new_beams[idx] += count
        else
          new_beams[idx-1] += count
          new_beams[idx+1] += count
          @splits += 1
        end
      end
      @beams = new_beams
    end
  end

  def one
    @splits
  end

  def two
    @beams.values.sum
  end
end
