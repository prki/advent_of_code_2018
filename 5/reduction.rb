# Problem definition: https://adventofcode.com/2018/day/5

def read_input
  ary = []
  File.open('./input.txt', 'r') do |file|
    file.each do |line|
      ary << line.to_s
    end
  end

  ary.freeze
end

def remove_any_polymer(ary_letters, str)
  # Solution creates combinations of 'xX' or 'Xx' and tries to delete them
  # from the string. If there is nothing to delete, returns false, while
  # loop ends.
  ary_letters.each do |letter|
    letter_upcase = letter.upcase
    comb1 = letter + letter_upcase
    return true if str.gsub!(comb1, '')
    comb2 = letter_upcase + letter
    return true if str.gsub!(comb2, '')
  end

  nil
end

def remove_reacting_polymers(str)
  ary_letters = ('a'..'z').to_a

  # As long as there can be anything removed, remove it, start from the
  # beginning (with 'a')
  while remove_any_polymer(ary_letters, str)
  end

  str
end

def remove_reacting_polymers_loop(str)
  idx = 0
  str_ret = str.dup
  while idx < str_ret.size - 1
    if str_ret[idx] == str_ret[idx + 1].swapcase || str_ret[idx].swapcase == str_ret[idx + 1]
      str_ret.slice!(idx, 2)
      idx -= 1 unless idx.zero?
    else
      idx += 1
    end
  end

  str_ret
end

def best_type_to_remove(str)
  ary_letters = ('a'..'z').to_a
  min_len = 99_999_999
  ary_letters.each do |letter|
    str_removed_symb = str.dup
    str_removed_symb.tr!(letter, '')
    str_removed_symb.tr!(letter.upcase, '')

    len_postreact = remove_reacting_polymers_loop(str_removed_symb).length

    min_len = len_postreact if len_postreact < min_len
  end

  min_len
end

input = read_input
input_str = input[0].delete("\n")

# test_str = 'dabAcCaCBAcCcaDA'
# test_str_out = remove_reacting_polymers(test_str)
# p test_str_out

input_str_out = remove_reacting_polymers_loop(input_str)

p(input_str_out.length)
p(best_type_to_remove(input_str))
