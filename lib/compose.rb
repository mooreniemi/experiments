require 'graph/function'
Graph::Function.as_gif(File.expand_path('../map_vs_compose.gif', __FILE__))

module Composition
  refine Proc do
    def compose
      proc do |i,x|
        self.(i.(x))
      end.curry
    end

    def * other
      self.compose.(other)
    end
  end
end
using Composition

DOUBLE = proc {|a| a * 2 }
TRIPLE = proc {|a| a * 3 }

def double_map(a)
  a.map(&DOUBLE).map(&TRIPLE)
end

def composed(a)
  a.map(&(DOUBLE * TRIPLE))
end

Graph::Function::IntsComparison.of(method(:double_map), method(:composed))
