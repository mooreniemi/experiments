require 'graph/function'
Graph::Function.configure do |config|
	config.trials = 1_000
	config.memory = true
end

def _sort(array)
	array.dup.sort { |a,b| a[:bar] <=> b[:bar] }.reverse
end

def _sort_by(array)
	array.dup.sort_by { |a| a[:bar] }.reverse!
end

Graph::Function.as_gif
# you must put it in a proc taking size so Graph::Function can increase it
generator = proc {|size| Rantly { array(size) { {:bar => integer} } } }
dict_comparison = Graph::Function::Comparison.new(generator)
# Comparison can take any number of Methods, but for now, 2
dict_comparison.of(method(:_sort), method(:_sort_by))
