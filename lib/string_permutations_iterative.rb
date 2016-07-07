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

        if !ENV['LOUD'].nil?
          # lets see whats on the stack as it executes
          # ie. https://gist.github.com/mooreniemi/2a00e89725d8b6884b28fcc9572d0163
          puts frame = "op_count: #{op_count}"
          puts "op: #{s.prefix} + #{prefix}"
          puts "current strings: #{strings.inspect}"
          puts "current stack: #{stack.map(&:to_s)}"
          puts "-" * frame.size
        end
      end

      strings << s.prefix if s.rest == ""
    end

    strings
  end
end
