require 'graph/function'
Graph::Function.as_gif(File.expand_path('../map_vs_compose.gif', __FILE__))
tiny_int_generator = proc {|size| Array.new(size) { rand(-9...9) } }
comparison = Graph::Function::Comparison.new(tiny_int_generator)

module Composition
  refine Proc do
    def compose
      proc do |i,x|
        self.(i.(x))
      end.curry
    end

    def uncurried_compose
      proc do |i|
        proc do |x|
          self.(i.(x))
        end
      end
    end

    def * other
      self.compose.(other)
    end
  end
end
using Composition

DOUBLE = proc {|a| a * 2 }
TRIPLE = proc {|a| a * 3 }

def double_triple
  (DOUBLE * TRIPLE)
end

def double_map(a)
  a.map(&DOUBLE).map(&TRIPLE)
end

def composed(a)
  a.map(&(DOUBLE * TRIPLE))
end

def cached_compose(a)
  a.map(&double_triple)
end

def uncurried_compose(a)
  a.map(&DOUBLE.uncurried_compose(&TRIPLE))
end

comparison.of(method(:double_map), method(:composed), method(:uncurried_compose), method(:cached_compose))
