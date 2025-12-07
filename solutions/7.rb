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
      new_beams = {}
      @beams.each do |idx, count|
        if line[idx] == "."
          new_beams[idx] = (new_beams[idx] || 0) + count
        else
          new_beams[idx-1] = (new_beams[idx-1] || 0) + count
          new_beams[idx+1] = (new_beams[idx+1] || 0) + count
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
    #timelines(0, @start, {})
  end

  def timelines(x, y, memo)
    memo[[x, y]] ||= begin
      if x == (@lines.length - 1)
        1
      elsif @lines[x][y] == "."
        timelines(x+1, y, memo)
      else
        timelines(x+1, y-1, memo) + timelines(x+1, y+1, memo)
      end
    end
  end
end
