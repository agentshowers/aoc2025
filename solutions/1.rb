require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day1 < Base
  DAY = 1

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @instructions = lines.map do |line|
      dir = line[0]
      steps = line[1..].to_i
      [dir, steps]
    end
  end

  def one
    pos = 50
    counts = 0
    @instructions.each do |dir, steps|
      if dir == "L"
        pos = (pos - steps) % 100
      else
        pos = (pos + steps) % 100
      end
      counts += 1 if pos == 0
    end
    counts
  end

  def two
    pos = 50
    counts = 0
    @instructions.each do |dir, steps|
      counts += steps / 100
      steps = steps % 100
      if dir == "L"
        counts += 1 if pos != 0 && pos <= steps
        pos = (pos - steps) % 100
      else
        counts += 1 if pos != 0 && pos + steps >= 100
        pos = (pos + steps) % 100
      end
    end
    counts
  end

end
