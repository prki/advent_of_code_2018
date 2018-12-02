def read_input
  ary = []
  File.open('./input.txt', 'r') do |file|
    file.each do |line|
      ary << line.to_s
    end
  end

  ary
end

def calc_checksum(boxes)
  doubles = 0
  triples = 0
  doubles_tmp = 0
  triples_tmp = 0

  boxes.each do |box|
    box.each_char do |char|
      doubles_tmp = 1 if box.count(char) == 2
      triples_tmp = 1 if box.count(char) == 3
    end

    if doubles_tmp == 1
      doubles_tmp = 0
      doubles += 1
    end
    if triples_tmp == 1
      triples_tmp = 0
      triples += 1
    end
  end

  doubles * triples
end

def single_diff_char?(str1, str2)
  diff_chars_num = 0
  str1.each_char.with_index do |char, index|
    if char != str2[index]
      diff_chars_num += 1
      return false if diff_chars_num > 1
    end
  end

  return true if diff_chars_num == 1
  false
end

def common_string(str1, str2)
  common_string = str1.dup
  str1.each_char.with_index do |char, index|
    if char != str2[index]
      common_string.slice!(index)
      return common_string
    end
  end
end

def find_similar_id(boxes)
  # A similar ID is one which differs by only one letter.
  # Returns the common string (missing the differing symbol)
  boxes.combination(2) do |box1, box2|
    return common_string(box1, box2) if single_diff_char?(box1, box2)
  end
end

boxes = read_input
p(calc_checksum(boxes))
p(find_similar_id(boxes))
