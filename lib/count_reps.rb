@get_matches = ->(source, substring) do
  upper = (source.size / substring.size).ceil
  search = (substring * upper).chars
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

@get_match_count = ->(source, substring) do
  (@get_matches.(source, substring) / substring.size).ceil
end

@get_max_sub = ->(source, substring) do
  result = (source.length / substring.length).downto(1).each_with_object(Hash.new(0)) do |multiplier, matches|
    match_count = @get_match_count.(source, substring * multiplier)
    matches[match_count] = multiplier
    break matches if match_count == 1
  end
  result[1]
end

@count_reps = ->(s1, n1, s2, n2) do
  reps = @get_match_count.(s1 * n1, s2)
  reps / n2
end

#p "#{get_max_sub.("abcabcmeowabcab", "abc")} should be 3"
#p "#{get_max_sub.("abcfaffbcmeowabcab", "abc")} should be 3"
#p "#{get_max_sub.("abcabcmeowabcab", "ab")} should be 4"
#p "#{get_max_sub.("abcabcmeowabcab", "a")} should be 4"
#p "#{get_max_sub.("acbbe", "abc")} should be 0"
#p "#{get_max_sub.("acbbe", "ab")} should be 1"
#p "#{get_max_sub.("acbbe", "b")} should be 2"
#p "#{get_max_sub.("babab", "baab")} should be 1"
#p "#{get_max_sub.("babababababababababababababababababababababa", "baab")} should be 7"
#p "#{get_max_sub.("lovelive" * 1000, "lovelive" * 999)} should be 1"
#p "#{get_max_sub.("niconiconi" * 99981, "nico" * 81)} should be 2468"
