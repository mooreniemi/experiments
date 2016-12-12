# http://mooreniemi.github.io/js/programming/2016/11/28/table-driven-methods.html
require 'graph/function'

Graph::Function.configure do |config|
  #config.trials = 1_000
  #config.memory = true
end

Graph::Function.as_gif(File.expand_path('../tdm.gif', __FILE__))

array_generator = proc {|size| Array.new(size) { [] } }
comparison = Graph::Function::Comparison.new(array_generator)

# by itself puts 2560 bytes on the heap, so out here for clarity
prng = Random.new
@is_live = prng.rand(0..1)
@num_live_neighbors = prng.rand(0..4)

LIVE = proc {|c| c.push(1) }
DIE = proc {|c| c.clear }

NEXT_LIVE_STATE = [DIE, DIE, LIVE, LIVE, DIE].freeze
NEXT_DEAD_STATE = [DIE, DIE, DIE, LIVE, DIE].freeze
NEXT_STATE = [NEXT_DEAD_STATE, NEXT_LIVE_STATE].freeze

def tdm(a)
  a.each {|e| NEXT_STATE[@is_live][@num_live_neighbors].(e) }
end

def if_else(a)
  a.each do |e|
    if @is_live == 0
      case @num_live_neighbors
      when 0
        DIE.(e)
      when 1
        DIE.(e)
      when 2
        LIVE.(e)
      when 3
        LIVE.(e)
      when 4
        DIE.(e)
      end
    else
      case @num_live_neighbors
      when 0
        DIE.(e)
      when 1
        DIE.(e)
      when 2
        DIE.(e)
      when 3
        LIVE.(e)
      when 4
        DIE.(e)
      end
    end
  end
end

comparison.of(method(:tdm), method(:if_else))

# https://github.com/michaelherold/benchmark-memory
require 'benchmark/memory'
Benchmark.memory do |x|
  x.report('tdm') { tdm(array_generator.(5)) }
  x.report('if_else') { if_else(array_generator.(5)) }
  x.compare!
end
