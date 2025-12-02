require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day2 < Base
  DAY = 2
  PATTERNS_1 = {
    1 => [],
    2 => [[1, 2]],
    3 => [],
    4 => [[2, 2]],
    5 => [],
    6 => [[3, 2]],
    7 => [],
    8 => [[4, 2]],
    9 => [],
    10 => [[5, 2]]
  }
  PATTERNS_2 = {
    1 => [],
    2 => [[1, 2]],
    3 => [[1, 3]],
    4 => [[2, 2], [1, 4]],
    5 => [[1, 5]],
    6 => [[1, 6], [2, 3], [3, 2]],
    7 => [[1, 7]],
    8 => [[1, 8], [2, 4], [4, 2]],
    9 => [[1, 9], [3, 3]],
    10 => [[1, 10], [2, 5], [5, 2]]
  }

  def initialize(type = "example")
    @ranges = Parser.read(DAY, type).split(",").map { |r| r.split("-") }
  end

  def one
    @ranges.map { |l, h| count_silly(l, h, PATTERNS_1) }.sum
  end

  def two
    @ranges.map { |l, h| count_silly(l, h, PATTERNS_2) }.sum
  end

  def count_silly(low, high, pats)
    patterns = pats[low.length]
    patterns += pats[high.length] if low.length != high.length

    ids = []

    patterns.each do |len, repeats|
      if low.length < len * repeats
        min = 10**(len - 1)
      else
        min_s = low.rjust(len*repeats, "0")[0..(len-1)]
        if (min_s * repeats).to_i < low.to_i
          min = min_s.to_i + 1
        else
          min = min_s.to_i
        end
      end

      if high.length > len * repeats
        max = ("9" * len).to_i
      else
        max_s = high[0..(len-1)]
        if (max_s * repeats).to_i > high.to_i
          max = max_s.to_i - 1
        else
          max = max_s.to_i
        end
      end

      while min <= max
        ids << (min.to_s  * repeats).to_i
        min += 1
      end
    end

    ids.uniq.sum
  end
end
