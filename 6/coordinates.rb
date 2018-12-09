# Problem definition: https://adventofcode.com/2018/day/6
# Trivial O(n^3) solution

WID = 400
HEI = 400

def read_input
  ary = []
  File.open('./input.txt', 'r') do |file|
    file.each do |line|
      ary << line.to_s
    end
  end

  ary.freeze
end

def test_inputs
  ['1, 1',
   '1, 6',
   '8, 3',
   '3, 4',
   '5, 5',
   '8, 9']
end

def parse_input(inputs)
  id = 1
  hash = {}

  inputs.each do |input|
    input.tr!(',', '')
    x = input.split[0]
    y = input.split[1]
    hash[id] = [x.to_i, y.to_i, 'FINITE']
    id += 1
  end

  hash
end

def set_markers(grid, input_hash)
  input_hash.each do |key, value|
    x = value[0]
    y = value[1]
    grid[y][x] = key
  end

  return grid
end

def infinite_area?(grid, row, col)
  return true if row + 1 == HEI || row == 0 || col + 1 == WID || col == 0
  false
end

def calc_manhattan_distance(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

def find_closest_marker(y, x, input_hash)
  # Returns ID of the closest marker
  shortest_distance = 99_999_999
  closest_marker = -1
  input_hash.each do |key, value|
    marker_x = value[0]
    marker_y = value[1]
    dist = calc_manhattan_distance(x, y, marker_x, marker_y)

    if dist < shortest_distance
      shortest_distance = dist
      closest_marker = key
    elsif dist == shortest_distance
      closest_marker = -1
    end
  end

  closest_marker
end

def fill_areas(grid, input_hash)
  # This method does two things:
  #   - Fills each position on the grid with the closest position
  #   - In case an area is infinite, updates that in input_hash
  grid.each_with_index do |row, row_idx|
    row.each_with_index do |pos, pos_idx|
      closest_id = find_closest_marker(row_idx, pos_idx, input_hash)
      grid[row_idx][pos_idx] = closest_id
      input_hash[closest_id][2] = 'INFINITE' if closest_id != -1 && infinite_area?(grid, row_idx, pos_idx)
    end
  end
end

def find_biggest_area(grid, hash)
  biggest_area = 0
  area_id = 0 # debug purposes
  hash.each do |key, value|
    next if value[2].eql?('INFINITE')
    id = key
    sum = 0
    grid.each do |row|
      sum += row.count { |cell| cell == id }
    end

    biggest_area = sum if sum > biggest_area
  end

  biggest_area
end

def build_grid(grid, input_hash)
  set_markers(grid, input_hash)
  fill_areas(grid, input_hash)
  # puts grid.map { |x| x.join(' ') }
end

inputs = read_input
#inputs = test_inputs
input_hash = parse_input(inputs)
grid = Array.new(HEI) { Array.new(WID) { 0 } }

build_grid(grid, input_hash)
area_size = find_biggest_area(grid, input_hash)
puts area_size
#width = grid.flatten.max.to_s.size+2
#puts grid.map { |x| x.join(' ') }
#puts grid.map { |a| a.map { |i| i.to_s.rjust(width) }.join }
