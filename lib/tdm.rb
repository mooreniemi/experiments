# http://mooreniemi.github.io/js/programming/2016/11/28/table-driven-methods.html
require 'graph/function'

Graph::Function.configure do |config|
  config.trials = 1000
end
Graph::Function.as_gif(File.expand_path('../tdm.gif', __FILE__))

array_generator = proc {|size| Array.new(size) { [] } }
comparison = Graph::Function::Comparison.new(array_generator)

def tdm(a)
  prng = Random.new
  is_live = prng.rand(0..1)
  num_live_neighbors = prng.rand(0..4)

  live = proc {|c| c.push(1) }
  die = proc {|c| c.clear }

  next_live_state = [die, die, live, live, die].freeze
  next_dead_state = [die, die, die, live, die].freeze
  next_state = [next_dead_state, next_live_state].freeze

  a.each {|e| next_state[is_live][num_live_neighbors].(e) }
end

def if_else(a)
  prng = Random.new
  is_live = prng.rand(0..1)
  num_live_neighbors = prng.rand(0..4)

  a.each do |e|
    if is_live == 0
      case num_live_neighbors
      when 0
        e.clear
      when 1
        e.clear
      when 2
        e.push(1)
      when 3
        e.push(1)
      when 4
        e.clear
      end
    else
      case num_live_neighbors
      when 0
        e.clear
      when 1
        e.clear
      when 2
        e.clear
      when 3
        e.push(1)
      when 4
        e.clear
      end
    end
  end
end


comparison.of(method(:tdm), method(:if_else))
