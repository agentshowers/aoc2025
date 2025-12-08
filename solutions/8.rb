require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day8 < Base
  DAY = 8

  def initialize(type = "example")
    @connections = (type == "example") ? 10 : 1000
    @points = Parser.lines(DAY, type).map { |line| line.scan(/\d+/).map(&:to_i) }
    @dists = @points.combination(2).map do |a, b|
      [a, b, distance(*a, *b)]
    end.sort_by { |_, _, dist| dist }
  end

  def one
    junctions = {}
    counter = 0
    (0..@connections-1).each do |i|
      a, b, dist = @dists[i]
      if !junctions[a]
        if !junctions[b]
          junctions[a] = counter
          junctions[b] = counter
          counter += 1
        else
          junctions[a] = junctions[b]
        end
      elsif !junctions[b]
        junctions[b] = junctions[a]
      elsif junctions[a] != junctions[b]
        keys = junctions.select { |_, v| v == junctions[b] }.keys
        keys.each {|k| junctions[k] = junctions[a] }
      end
    end
    junctions.values.tally.values.sort_by { |v| -v }.take(3).reduce(:*)
  end

  def two
    junctions = {}
    added = 0
    boxes = 0
    counter = 0
    @dists.each do |a, b, _|
      if !junctions[a]
        if !junctions[b]
          junctions[a] = counter
          junctions[b] = counter
          counter += 1
          boxes += 1
          added += 2
        else
          junctions[a] = junctions[b]
          added += 1
        end
      elsif !junctions[b]
        junctions[b] = junctions[a]
        added += 1
      elsif junctions[a] != junctions[b]
        keys = junctions.select { |_, v| v == junctions[b] }.keys
        keys.each {|k| junctions[k] = junctions[a] }
        boxes -= 1
      end
      return a[0] * b[0] if boxes == 1 && added == @points.length
    end
    -1
  end

  def distance(x1, y1, z1, x2, y2, z2)
    Math.sqrt((x2-x1).pow(2) + (y2-y1).pow(2) + (z2-z1).pow(2))
  end
end
