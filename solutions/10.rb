require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day10 < Base
  DAY = 10

  def initialize(type = "example")
    lines = Parser.lines(DAY, type)
    @machines = lines.map do |line|
      parse_line(line)
    end
  end

  def parse_line(line)
    bracket_match = line.match(/\[([.#]+)\]/)
    pattern = bracket_match[1]
    length = pattern.length

    result = pattern.chars.map { |c| c == '#' ? "1" : "0" }.join.to_i(2)

    buttons = line.scan(/\(([^)]+)\)/).map do |match|
      indices = match[0].split(',').map(&:to_i)
      Array.new(length) { |i| indices.include?(i) ? "1" : "0" }.join.to_i(2)
    end

    brace_match = line.match(/\{([^}]+)\}/)
    values = brace_match[1].split(',').map(&:to_i)

    [result, buttons, values]
  end


  def one
    @machines.map do |m|
      solve(m[0], m[1])
    end.sum
  end

  def solve(result, buttons)
    visited = {}
    steps = [[0, 0]]
    loop do
      pos, clicks = steps.shift
      next if visited[pos]
      visited[pos] = true
      buttons.each do |b|
        next_p = pos ^ b
        return clicks + 1 if next_p == result
        steps << [next_p, clicks + 1] if !visited[next_p]
      end
    end
  end

  def two
    2
  end
end
