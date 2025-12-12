require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day12 < Base
  DAY = 12

  def initialize(type = "example")
    sections = Parser.read(DAY, type).split("\n\n")
    @presents = sections[0..5].map { |l| l.count("#") }
    @regions = sections.last.split("\n").map do |l|
      s, c = l.split(": ")
      [s.split("x").map(&:to_i), c.split(" ").map(&:to_i)]
    end

  end

  def one
    count = 0
    @regions.each do |(w, h), counts|
      region_size = w * h
      presents_size = counts.each_with_index.map do |c, i|
        c * @presents[i]
      end.sum
      count += 1 if presents_size <= region_size
    end
    count
  end

  def two
    "⭐️"
  end
end
