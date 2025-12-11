require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day11 < Base
  DAY = 11

  def initialize(type = "example")
    @type = type
    parse
    calc_paths
  end

  def parse(version = "")
    lines = Parser.lines(DAY, @type, version)
    @map = {}
    lines.each do |line|
      src, dests = line.split(": ")
      @map[src] = dests.split(" ")
    end
  end

  def one
    @out_paths["you"]
  end

  def two
    if @type == "example"
      parse("b")
      calc_paths
    end

    @fft_paths["svr"] * @dac_paths["fft"] * @out_paths["dac"]
  end

  def calc_paths
    @out_paths = { "out" => 1 }
    @dac_paths = { "dac" => 1 }
    @fft_paths = { "fft" => 1 }
    loop do
      @map.each do |src, dsts|
        if dsts.all? { |d| @out_paths[d] }
          @out_paths[src] = dsts.map { |d| @out_paths[d] }.sum
          @dac_paths[src] ||= dsts.map { |d| @dac_paths[d] || 0 }.sum
          @fft_paths[src] ||= dsts.map { |d| @fft_paths[d] || 0 }.sum
          @map.delete(src)
        end
      end
      break if @map.empty?
    end
  end
end
