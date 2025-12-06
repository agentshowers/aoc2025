require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day6 < Base
  DAY = 6

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @numbers = lines[0..-2]
    @operations = lines[-1].chars.each_with_index.filter_map do |c, i|
      next if c == " "
      [c, i]
    end
  end

  def one
    @operations.each_with_index.map do |(op, i), idx|
      j = (idx == (@operations.length - 1) ? @numbers[0].length - 1 : @operations[idx+1][1] - 2)
      @numbers.map { |n| n[i..j].to_i }.reduce(op.to_sym)
    end.sum
  end

  def two
    @operations.each_with_index.map do |(op, i), idx|
      j = (idx == (@operations.length - 1) ? @numbers[0].length - 1 : @operations[idx+1][1] - 2)
      (i..j).map do |x|
        @numbers.map { |n| n[x] }.join.to_i
      end.reduce(op.to_sym)
    end.sum
  end
end
