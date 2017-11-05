indexed_character_cycle = ->(string) { string.chars.cycle.with_index }

get_matches = ->(source,substring) do
  bag = indexed_character_cycle.(substring)
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

get_match_count = ->(source, substring) do
  get_matches.(source, substring).compact.size
end

get_max_sub = ->(source,substring) do
  unused = source.chars - substring.chars
  source = (source.chars - unused).join
  result = (1..Float::INFINITY).each_with_object(Hash.new(0)) do |multiplier, matches|
    match_count = get_match_count.(source, substring * multiplier)
    break matches if match_count == 0
    matches[match_count] = multiplier
  end
  result[result.keys.min]
end

p get_max_sub.("abcabcmeowabcab", "abc")
p get_max_sub.("abcfaffbcmeowabcab", "abc")
p get_max_sub.("abcabcmeowabcab", "ab")
p get_max_sub.("abcabcmeowabcab", "a")
p get_max_sub.("acbbe", "abc")
p get_max_sub.("acbbe", "ab")
p get_max_sub.("acbbe", "b")
