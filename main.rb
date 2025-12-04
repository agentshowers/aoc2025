#!/usr/bin/env ruby

require 'json'
require 'optparse'
require 'uri'
require 'net/http'
require 'dotenv'

DAYS = 4

SOLUTIONS = {
  1 => [1086, 6268],
  2 => [22062284697, 46666175279],
  3 => [17535, 173577199527257],
  4 => [1449, 8746]
}

Dotenv.load

def solve(range)
  range.map do |n|
    printf("\r\e[KSolving #{n}/#{DAYS}")
    require_relative "solutions/#{n}.rb"

    day_class = Kernel.const_get("Day#{n}")
    t1 = Time.now
    day = day_class.new("input")
    res1 = day.one
    res2 = day.two
    t2 = Time.now
    time = 1000.0 * (t2 - t1)

    [n, res1, res2, time]
  end
end

def pretty_print(solutions)
  printf("\r\e[K")
  total_time = solutions.map {_1[3]}.sum

  puts "--------------------------------------------------------------------------------------"
  puts "| Day | Part 1               | Part 2                                   | Time       |"
  puts "--------------------------------------------------------------------------------------"


  solutions.each do |day, pt1, pt2, time|
    pt1_color = SOLUTIONS[day] && SOLUTIONS[day][0] != pt1 ? 31 : 0
    pt2_color = SOLUTIONS[day] && SOLUTIONS[day][1] != pt2 ? 31 : 0
    if time < 100.0
      color_code = 32
    elsif time < 1000.0
      color_code = 33
    else
      color_code = 31
    end
    time_str = "#{time.round(2).to_s} ms"
    puts sprintf("| %-3s | \e[#{pt1_color}m%-20s\e[0m | \e[#{pt2_color}m%-40s\e[0m | \e[#{color_code}m%-10s\e[0m |", day, pt1, pt2, time_str)
  end

  puts "-------------------------------------------------------------------------------------\n"
  puts " "*42 + "Total time: #{total_time.round(2)} ms"
end


range = (1..DAYS)

puts "**************************************************************************************"
puts "*                                                                                    *"
puts "*                            🎄🎄 Advent of Code #{ENV['YEAR']} 🎄🎄                           *"
puts "*                                                                                    *"
puts "**************************************************************************************"
puts ""

solutions = solve(range)
pretty_print(solutions)
