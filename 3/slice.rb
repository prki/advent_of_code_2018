def read_input
  ary = []
  File.open('./input.txt', 'r') do |file|
    file.each do |line|
      ary << line.to_s
    end
  end

  ary.freeze
end

def parse_areas(areas)
  # Each fabric cut is in the string form '#ID @ X,Y: WxH'
  # Returns a 2D array where each elem is ['ID', 'X', 'Y', 'W', 'H'] (to_i)
  ary = []
  areas.each do |line|
    split_str = line.split
    id = split_str[0].tr('#', '').to_i
    x = split_str[2].split(',')[0].to_i
    y = split_str[2].split(',')[1].tr(':', '').to_i
    w = split_str[3].split('x')[0].to_i
    h = split_str[3].split('x')[1].to_i
    ary << [id, x, y, w, h]
  end

  ary
end

def fill_fabric(id, x, y, w, h, fabric)
  fabric[y, h].each do |row|
    row[x, w].each do |cell|
      cell << id
    end
  end
end

def set_overlapping_areas(fabric, fabric_cuts)
  fabric_cuts.each do |fabric_cut|
    id = fabric_cut[0]
    x = fabric_cut[1]
    y = fabric_cut[2]
    w = fabric_cut[3]
    h = fabric_cut[4]
    fill_fabric(id, x, y, w, h, fabric)
  end

  fabric
end

def find_good_claim(fabric, fabric_cuts)
  cut = fabric_cuts.select do |fabric_cut|
    id = fabric_cut[0]
    x = fabric_cut[1]
    y = fabric_cut[2]
    w = fabric_cut[3]
    h = fabric_cut[4]
    fabric[y, h].all? do |row|
      row[x, w].all? do |cell|
        cell.size == 1
      end
    end
  end

  cut
end

areas = read_input
fabric_cuts = parse_areas(areas)
#areas = ['#1 @ 3,2: 4x4']
wid = 2000
hei = 2000
fabric = Array.new(hei) { Array.new(wid) { [] } }

set_overlapping_areas(fabric, fabric_cuts)
sum = 0
fabric.each do |row|
  sum += row.count { |cell| cell.size >= 2 }
end
p(sum)

good_claim = find_good_claim(fabric, fabric_cuts)
p(good_claim[0])
