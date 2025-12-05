require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day5 < Base
  DAY = 5

  class Range
    attr_accessor :low, :high, :next

    def initialize(low, high, next_r = nil)
      @low = low
      @high = high
      @next = next_r
    end
  end

  def initialize(type = "example")
    @range_list = nil
    r, i = Parser.read(DAY, type).split("\n\n")
    r.split("\n").each do |line|
      l, h = line.split("-").map(&:to_i)
      @range_list = insert_range(l, h, @range_list)
    end
    @ingredients = i.split("\n").map(&:to_i)
  end

  def one
    count = 0
    @ingredients.each do |i|
      range = @range_list
      while range
        if i >= range.low && i <= range.high
          count += 1
          break
        end
        range = range.next
      end
    end
    count
  end

  def two
    sum = 0
    range = @range_list
    while range
      sum += (range.high - range.low + 1)
      range = range.next
    end
    sum
  end

  def insert_range(l, h, node)
    return Range.new(l, h) if node.nil?

    if node.low > h
      node = Range.new(l, h, node)
    elsif node.high < l
      node.next = insert_range(l, h, node.next)
    elsif node.low > l || node.high < h
      if node.high >= h
        node.low = l
      else
        node.low = l if node.low > l
        while h > node.high
          if !node.next || node.next.low > h
            node.high = h
          else
            node.high = node.next.high
            node.next = node.next.next
          end
        end
      end
    end

    node
  end
end
