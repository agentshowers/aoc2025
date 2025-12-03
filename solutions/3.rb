require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day3 < Base
  DAY = 3

  def initialize(type = "example")
    @lines = Parser.lines(DAY, type)
  end

  def one
    @lines.map { |l| maximum(2, l) }.sum
  end

  def two
    @lines.map { |l| maximum(12, l) }.sum
  end

  def maximum(digits, line)
    max = [0] * digits
    remaining = line.length

    line.chars.each do |char|
      n = 0
      stop = false
      while n < digits && !stop
        if max[n] < char.to_i && (remaining >= (digits - n))
          max[n] = char.to_i
          max[(n+1)..] = [0] * (digits - n - 1)
          stop = true
        end
        n += 1
      end
      remaining -= 1
    end

    max.join.to_i
  end
end
