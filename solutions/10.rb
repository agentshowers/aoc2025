require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"
require "z3"

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

    buttons = []
    binary_buttons = []
    line.scan(/\(([^)]+)\)/).each do |match|
      indices = match[0].split(',').map(&:to_i)
      bins = Array.new(length) { |i| indices.include?(i) ? 1 : 0 }
      buttons << bins
      binary_buttons << bins.join.to_i(2)
    end

    brace_match = line.match(/\{([^}]+)\}/)
    values = brace_match[1].split(',').map(&:to_i)

    [result, binary_buttons, buttons, values]
  end


  def one
    @machines.map do |m|
      solve_one(m[0], m[1])
    end.sum
  end

  def solve_one(result, buttons)
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
    @machines.map do |m|
      solve_two(m[2], m[3])
    end.sum
  end

  def solve_two(buttons, voltages)
    optimizer = Z3::Optimize.new

    vars = (0..buttons.length-1).map do |i|
      var = Z3.Int("x#{i+1}")
      optimizer.assert(var >= 0)
      var
    end

    voltages.each_with_index do |v, i|
      mask = buttons.map { |b| b[i] }
      dot_product = vars.zip(mask).map { |v, c| v * c }.reduce(:+)
      optimizer.assert(dot_product == v)
    end

    optimizer.minimize(vars.sum)
    if optimizer.satisfiable?
      model = optimizer.model
      return model.map { |var| model[var].to_i }.sum
    end

    raise new "Oh fuck"
  end
end
