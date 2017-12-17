=begin
Longest Common Substring

A Substring is ordered and contiguous.

The naive implementation is just to generate
all possible substrings then take the longest
intersecting substring.

For generation of Substrings:
http://www.geeksforgeeks.org/program-print-substrings-given-string/
=end

@substrings = ->(s) do
  subs = []
  1.upto(s.size) do |n|
    s.chars.each_cons(n) do |ss|
      subs << ss
    end
  end
  subs.map(&:join)
end

puts "substrings: #{@substrings.('abcdgh')}"

@naive_lcsubstring = ->(a,b) do
  (@substrings.(a) & @substrings.(b)).max_by(&:length)
end

=begin
Longest Common Subsequence

A Subsequence does not need to be continuous,
but remains ordered, which distinguishes it from
a permutation.

For generation of all Subsequences:
http://www.geeksforgeeks.org/print-subsequences-string/
=end

require 'set'
@subsequences = ->(s, set=Set.new) do
  s.chars.each_with_index do |_,i|
    (s.size-1).downto(i) do |j|
      sub_str = s[i..j]
      set << sub_str unless sub_str == ""

      1.upto(sub_str.size-1) do |k|
        sb = sub_str.dup.tap {|ss| ss.slice!(k) }
        @subsequences.(sb, set) unless set.member?(sb)
      end
    end
  end
  set.to_a
end

#puts @subsequences.('aabc').sort == ['aa', 'a', 'ab', 'bc', 'ac', 'b', 'aac', 'abc', 'c', 'aab', 'aabc'].sort

puts "subsequences: #{@subsequences.("abcdgh")}"

@naive_lcsubseq = ->(a,b) do
  (@subsequences.(a) & @subsequences.(b)).max_by(&:length)
end
