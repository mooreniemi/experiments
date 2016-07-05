# http://www.geeksforgeeks.org/permutations-string-using-iteration/

class String

  Struct.new("PermuteOp", :prefix, :rest)

  def permutations
    strings = []
    stack = [Struct::PermuteOp.new("", self)]

    while !stack.empty?
      s = stack.pop
      s.rest.length.times do |i|
        copy = s.rest.dup
        prefix = copy.slice!(i)
        stack.push(Struct::PermuteOp.new(s.prefix + prefix, copy))
      end
      strings << s.prefix if s.rest == ""
    end

    strings.uniq
  end
end
