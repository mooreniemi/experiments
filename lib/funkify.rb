require 'funkify'
require 'graph/function'
Graph::Function.as_gif(File.expand_path('../funkify.gif', __FILE__))
tiny_int_generator = proc {|size| Array.new(size) { rand(-9...9) } }
comparison = Graph::Function::Comparison.new(tiny_int_generator)

module Composition
	refine Proc do
		def compose
			proc do |i,x|
				self.(i.(x))
			end.curry
		end

		def % other
			self.compose.(other)
		end
	end
end

class Composer
	def double
		proc {|a| a * 2 }
	end
	def triple
		proc {|a| a * 3 }
	end
end

class MyFunkyClass
	include Funkify
	# alternatively, if we invoke auto_curry without a parameter
	# then all subsequent methods will be autocurried
	auto_curry

	def mult(x, y)
		x * y
	end

	def negate(x)
		-x
	end
end

def double_map(a)
  a.map(&Composer.new.double).map(&Composer.new.triple)
end

def funkify(a)
	a.map(&(MyFunkyClass.new.negate * MyFunkyClass.new.mult(10)))
end

using Composition
def composed(a)

	a.map(&(Composer.new.double % Composer.new.triple))
end

comparison.of(method(:double_map), method(:composed), method(:funkify))
