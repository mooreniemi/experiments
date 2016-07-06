# http://www.geeksforgeeks.org/permutations-string-using-iteration/

class String
  # this simulates what goes to the call stack
  PermuteOp = Struct.new(:prefix, :rest) do
    def to_s
      "#{prefix}:#{rest}"
    end
  end

  def permutations
    strings = []
    stack = [PermuteOp.new("", self)]
    op_count = 0

    while !stack.empty?
      s = stack.pop
      s.rest.length.times do |i|
        op_count += 1
        copy = s.rest.dup
        prefix = copy.slice!(i)

        stack.push(PermuteOp.new(s.prefix + prefix, copy))

        # lets see whats on the stack as it executes
        puts frame = "op_count: #{op_count}"
        puts "fixed: #{s.prefix}"
        puts "current strings: #{strings.inspect}"
        puts "current stack: #{stack.map(&:to_s)}"
        puts "-" * frame.size
      end

      strings << s.prefix if s.rest == ""
    end

    strings
  end
end
