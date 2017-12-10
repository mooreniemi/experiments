RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

require './lib/day5.rb'
p jumper(@input,@input.first,@input[@input.first],1)
