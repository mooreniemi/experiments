get_matches = ->(source, substring) do
  search = (substring * source.length).chars
  matched = 0
  source.chars.each do |source_char|
    target_char = search.shift
    if source_char == target_char
      matched += 1
    else
      search.unshift(target_char)
    end
  end
  matched
end

get_match_count = ->(source, substring) do
  get_matches.(source, substring) / substring.size
end

get_max_sub = ->(source,substring) do
  result = (1..Float::INFINITY).each_with_object(Hash.new(0)) do |multiplier, matches|
    match_count = get_match_count.(source, substring * multiplier)
    break matches if match_count == 0
    matches[match_count] = multiplier
  end
  result[result.keys.min]
end

p "#{get_max_sub.("abcabcmeowabcab", "abc")} should be 3"
p "#{get_max_sub.("abcfaffbcmeowabcab", "abc")} should be 3"
p "#{get_max_sub.("abcabcmeowabcab", "ab")} should be 4"
p "#{get_max_sub.("abcabcmeowabcab", "a")} should be 4"
p "#{get_max_sub.("acbbe", "abc")} should be 0"
p "#{get_max_sub.("acbbe", "ab")} should be 1"
p "#{get_max_sub.("acbbe", "b")} should be 2"
p "#{get_max_sub.("babab", "baab")} should be 1"
p "#{get_max_sub.("babababababababababababababababababababababa", "baab")} should be 7"
