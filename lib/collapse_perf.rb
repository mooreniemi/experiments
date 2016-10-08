require 'array_collapse'

require 'graph/function'
Graph::Function.as_gif
Graph::Function.configure do |c|
  c.trials = 10_000
end

DOUBLE = proc { |a| a * 2 }

def flatten_map(array)
  array.flatten.map(&DOUBLE)
end

def collapse(array)
  array.collapse(&DOUBLE)
end

Graph::Function::IntsComparison.of(method(:flatten_map), method(:collapse))
