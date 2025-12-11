require "./lib/parser.rb"
require "./lib/base.rb"
require "./lib/grid/matrix.rb"

class Day11Copy < Base
  DAY = 11

  def initialize(type = "example")
    @type = type
    parse
    calc_paths
  end

  def parse(version = "")
    lines = Parser.lines(DAY, @type, version)
    @indexes = {}
    @map = Hash.new { |h, k| h[k] = [] }
    lines.each do |line|
      src, dests = line.split(": ")
      @indexes[src] = @indexes.length unless @indexes[src]
      src_idx = @indexes[src]
      dests.split(" ").each do |dst|
        @indexes[dst] = @indexes.length unless @indexes[dst]
        @map[src_idx] << @indexes[dst]
      end
    end
    @dac = @indexes["dac"]
    @fft = @indexes["fft"]
    @svr = @indexes["svr"]
    @you = @indexes["you"]
    @out = @indexes["out"]
  end

  def one
    @out_paths[@you]
  end

  def two
    if @type == "example"
      parse("b")
      calc_paths
    end

    @fft_paths[@svr] * @dac_paths[@fft] * @out_paths[@dac]
  end

  def calc_paths
    @out_paths = { @out => 1 }
    @dac_paths = { @dac => 1 }
    @fft_paths = { @fft => 1 }
    found_dac = false
    found_fft = false
    loop do
      changed = false
      @map.each do |idx, dsts|
        if !@out_paths[idx] && dsts.all? { |d| @out_paths[d] }
          @out_paths[idx] = dsts.map { |d| @out_paths[d] }.sum
          @dac_paths[idx] = dsts.map { |d| @dac_paths[d] || 0 }.sum if found_dac
          @fft_paths[idx] = dsts.map { |d| @fft_paths[d] || 0 }.sum if found_fft
          found_dac = true if idx == @dac
          found_fft = true if idx == @fft
          @map.delete(idx)
          changed = true
        end
      end
      break if !changed
    end
  end

  def paths(src, dest, visited, memo)
    key = "#{src}-#{visited}"
    return memo[key] if memo[key]
    visited = visited | 2.pow(src)
    res = []
    @map[src].each do |device|
      if device == dest
        res << visited
      elsif visited & 2.pow(device) == 0
        res += paths(device, dest, visited, memo)
      end
    end
    memo[key] = res
    res
  end
end
