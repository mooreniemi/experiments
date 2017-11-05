cyi = ->(string) { string.chars.cycle.with_index }

get_matches = ->(source,substring) do
  bag = cyi.(substring)
  bag_end = substring.size - 1
  source.chars.map do |char|
    bag_char, bag_index = bag.next
    if char == bag_char
      if bag_index == bag_end
        bag.rewind
        true
      end
    else
      bag.rewind
      nil
    end
  end
end

get_max_sub = ->(source,substring) do
  unused = source.chars - substring.chars
  source = (source.chars - unused).join
  result = (1..Float::INFINITY).each_with_object(Hash.new(0)) do |n, matches|
    m = get_matches.(source, substring * n).compact.size
    break matches if m == 0
    matches[m] = n
  end
  result[result.keys.min]
end

p get_max_sub.("abcabcmeowabcab", "abc")
p get_max_sub.("abcabcmeowabcab", "ab")
p get_max_sub.("abcabcmeowabcab", "a")
p get_max_sub.("acbbe", "abc")
p get_max_sub.("acbbe", "ab")
p get_max_sub.("acbbe", "b")
