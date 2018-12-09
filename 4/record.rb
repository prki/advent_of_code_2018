# O(n log n) solution due to sort.
# O(n) solution possible but chronological order makes this far easier
# to implement and understand. (thus O(n log n) due to sort)

def read_input
  ary = []
  File.open('./input.txt', 'r') do |file|
    file.each do |line|
      ary << line.to_s
    end
  end

  ary.freeze
end

def guard_sleep_beforemidnight(chrono_inputs)
  # Test method for implementation purposes - make sure that
  # the minutes in the sleep interval are enough for the implementation
  # and the hour is not needed (a guard does not fall asleep before 00:00)
  # although this was stated in the problem definition, ebin.
  chrono_inputs.each do |input|
    return true if input[1].eql?('falls') && input[0].hour == 23
  end

  false
end

def parse_line(line)
  # Line format: [YYYY-MM-DD HH:MM] falls|wakes|GUARD
  # GUARD ::= Guard #ID begins shift ;; #ID ::= num
  # return array [Y, M, D, H, M, falls|wakes|guard, id|nil]
  # year + 500 - done so that the date can be timestamped
  line = line.tr('[', '').tr(']', '').tr('-', ' ').tr(':', ' ').tr('#', '')
  line = line.split
  timestamp = Time.new(line[0].to_i + 500, line[1], line[2], line[3], line[4])
  state = line[5]
  id = line[6].to_i if line[5].eql?('Guard')

  [timestamp, state, id]
end

def sort_inputs(inputs)
  chronological_inputs = []

  inputs.each do |input|
    chronological_inputs << parse_line(input)
  end

  chronological_inputs.sort! { |x, y| x[0] <=> y[0] }
end

def merge_sleeptimes(hash, guard_id, ary)
  # Merges the sleep occurence with the accumulated sleeptimes of a guard
  return hash[guard_id] = ary if hash[guard_id].nil?

  ary2 = hash[guard_id]
  ary_new = []
  ary.each_with_index do |x, idx|
    ary_new << x + ary2[idx]
  end

  hash[guard_id] = ary_new
end

def add_sleeptime_to_hash(hash, guard_id, falls_minute, wakes_minute)
  ary = Array.new(60) { 0 }
  ary.each_with_index do |_, idx|
    ary[idx] = 1 if idx.between?(falls_minute, wakes_minute - 1)
  end

  merge_sleeptimes(hash, guard_id, ary)
end

def build_hash(chrono_inputs, hash_guards_asleep)
  guard_id = -1
  falls_minute = -1
  wakes_minute = -1
  chrono_inputs.each do |input|
    if input[1].eql?('Guard')
      guard_id = input[2]
    elsif input[1].eql?('falls')
      falls_minute = input[0].min
    else
      wakes_minute = input[0].min
      add_sleeptime_to_hash(hash_guards_asleep, guard_id, falls_minute,
                            wakes_minute)
    end
  end

  hash_guards_asleep
end

def who_is_sleepyboi(hash)
  total_sleep_max = 0
  sleepyboi = 0
  hash.each do |key, value|
    total_sleep = value.sum
    if total_sleep > total_sleep_max
      total_sleep_max = total_sleep
      sleepyboi = key
    end
  end

  sleepyboi
end

def sleepyboi_most_slept_minute(hash, sleepyboi_id)
  ary = hash[sleepyboi_id]
  ary.each_with_index.max[1]
end

def most_frequent_sleepyboi(hash)
  # Most frequent minute is the maximum value in any of the arrays
  most_frequent_max = 0
  sleepyboi = 0
  hash.each do |key, value|
    most_frequent = value.max
    if most_frequent > most_frequent_max
      most_frequent_max = most_frequent
      sleepyboi = key
    end
  end

  sleepyboi
end

inputs = read_input
chronological_inputs = sort_inputs(inputs)
# puts chronological_inputs
# puts guard_sleep_beforemidnight(chronological_inputs)
hash_guards_asleep = {}

build_hash(chronological_inputs, hash_guards_asleep)
sleepyboi = who_is_sleepyboi(hash_guards_asleep)
p('Sleepyboi:', sleepyboi)

most_slept_minute = sleepyboi_most_slept_minute(hash_guards_asleep, sleepyboi)
p('Most slept:', most_slept_minute)

multiplication = sleepyboi * most_slept_minute
p('Multiplication:', multiplication)

sleepyboi = most_frequent_sleepyboi(hash_guards_asleep)
idx = sleepyboi_most_slept_minute(hash_guards_asleep, sleepyboi)
p(sleepyboi * idx)
