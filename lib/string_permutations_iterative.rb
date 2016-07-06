# http://www.geeksforgeeks.org/permutations-string-using-iteration/

class String
  # this simulates what goes to the call stack
  PermuteOp = Struct.new(:prefix, :rest) do
    def to_s
      "prefix: #{prefix}, rest: #{rest}"
    end
  end

  def permutations
    strings = []
    stack = [PermuteOp.new("", self)]

    while !stack.empty?
      s = stack.pop
      s.rest.length.times do |i|
        copy = s.rest.dup
        prefix = copy.slice!(i)

        new_op = PermuteOp.new(s.prefix + prefix, copy)
        puts new_op

        stack.push(new_op)
      end

      strings << s.prefix if s.rest == ""
    end

    strings
  end
end
