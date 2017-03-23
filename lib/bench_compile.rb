require 'benchmark'

avg = proc {|a| a.reduce(0, :+) / a.length }

compiled = RubyVM::InstructionSequence.compile(
  "Array.new(10_000) {|e| e.to_s(2) }"
)
string = "Array.new(10_000) {|e| e.to_s(2) }"

compiled_times = []
10_000.times do |i|
  compiled_times << Benchmark.measure do
    compiled.eval
  end.real
end
p "compiled_times avg: #{avg.(compiled_times)}"

eval_times = []
10_000.times do |i|
  eval_times << Benchmark.measure do
    eval(string)
  end.real
end
p "eval_times avg: #{avg.(eval_times)}"

normal_times = []
10_000.times do |i|
  normal_times << Benchmark.measure do
    Array.new(10_000) {|e| e.to_s(2) }
  end.real
end
p "normal_times avg: #{avg.(normal_times)}"

# "compiled_times avg: 0.003574442232507863"
# "eval_times avg: 0.003598988630728127"
# "normal_times avg: 0.0032835820019990933"
