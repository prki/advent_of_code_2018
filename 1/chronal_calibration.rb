require 'set'

# Problem definition
# https://adventofcode.com/2018/day/1

# part one
# freq = 0
# File.open('./input.txt', 'r') do |file|
#   file.each do |line|
#     val = line.to_i
#     freq += val
#   end
# end

# puts(freq)

# part two

set = Set.new
ary = []
File.open('./input.txt', 'r') do |file|
  file.each do |line|
    val = line.to_i
    ary << val
  end
end

freq = 0
loop do
  ary.each do |num|
    freq += num
    if set.add?(freq).nil?
      p(freq)
      exit
    end
  end
end
