fib = 'fib = Hash.new {|h, k| h[k] = h[k-1] + h[k-2] }.merge(0 => 0, 1 => 1); fib[10_1000]'
puts RubyVM::InstructionSequence.new(fib).disasm

