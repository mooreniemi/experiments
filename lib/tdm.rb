# http://mooreniemi.github.io/js/programming/2016/11/28/table-driven-methods.html
require 'graph/function'

Graph::Function.configure do |config|
  #config.trials = 1_000
  config.memory = true
end

Graph::Function.as_gif(File.expand_path('../tdm.gif', __FILE__))

array_generator = proc {|size| Array.new(size) { [] } }
comparison = Graph::Function::Comparison.new(array_generator)

# by itself puts 2560 bytes on the heap, so out here for clarity
prng = Random.new
@is_live = prng.rand(0..1)
@num_live_neighbors = prng.rand(0..4)

def tdm(a)
  live = proc {|c| c.push(1) }
  die = proc {|c| c.clear }

  next_live_state = [die, die, live, live, die].freeze
  next_dead_state = [die, die, die, live, die].freeze
  next_state = [next_dead_state, next_live_state].freeze

  a.each {|e| next_state[@is_live][@num_live_neighbors].(e) }
end

def if_else(a)
  live = proc {|c| c.push(1) }
  die = proc {|c| c.clear }

  a.each do |e|
    if @is_live == 0
      case @num_live_neighbors
      when 0
        die.(e)
      when 1
        die.(e)
      when 2
        live.(e)
      when 3
        live.(e)
      when 4
        die.(e)
      end
    else
      case @num_live_neighbors
      when 0
        die.(e)
      when 1
        die.(e)
      when 2
        die.(e)
      when 3
        live.(e)
      when 4
        die.(e)
      end
    end
  end
end

comparison.of(method(:tdm), method(:if_else))

require 'benchmark/memory'
Benchmark.memory do |x|
  x.report('tdm') { tdm(array_generator.(5)) }
  x.report('if_else') { if_else(array_generator.(5)) }
  x.compare!
end
