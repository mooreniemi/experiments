# https://stackoverflow.com/questions/2779094/what-algorithm-can-calculate-the-power-set-of-a-given-set
def powerset!(set)
  return [set] if set.empty?

  p = set.pop
  subset = powerset!(set)
  subset | subset.map {|x| x | [p] }
end

p powerset!([1,2,3])
p powerset!(%w{a b c d}).map(&:join)
# can be used to get subsequences
p (powerset!(%w{a b c d g h}).map(&:join) & powerset!(%w{a e d f h r}).map(&:join)).max_by(&:length)
