require 'benchmark'

a = Array.new(1_000_000, 1)

Benchmark.bmbm(100) do |x|
  x.report("inline, self=main") { a.each {|e| self && e } }
  x.report("assigned") { a.each {|e| a && e } }
  x.report("inline, instance_eval") { a.instance_eval { each {|e| self && e } } }
end
