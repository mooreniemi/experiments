require 'gnuplot'
require 'benchmark'

class Array
	def mine
		return 0 if self.size < 3
		# any comparison sort cant do better than n log n
		self.sort {|a,b| a.abs <=> b.abs }[-3..-1].reduce(1, :*)
	end

	def theirs
		# https://www.interviewcake.com/question/ruby/highest-product-of-3
		# a truly linear answer
		if self.length < 3
			return 0
			#raise Exception, 'Less than 3 items!'
		end

		# We're going to start at the 3rd item (at index 2)
		# so pre-populate highests and lowests based on the first 2 items.
		# we could also start these as nil and check below if they're set
		# but this is arguably cleaner
		highest = [self[0], self[1]].max
		lowest =  [self[0], self[1]].min

		highest_product_of_2 = self[0] * self[1]
		lowest_product_of_2  = self[0] * self[1]

		# except this one--we pre-populate it for the first /3/ items.
		# this means in our first pass it'll check against itself, which is fine.
		highest_product_of_three = self[0] * self[1] * self[2]

		# walk through items, starting at index 2
		self.each_with_index do |current, index|
			next if index < 2

			# do we have a new highest product of 3?
			# it's either the current highest,
			# or the current times the highest product of two
			# or the current times the lowest product of two
			highest_product_of_three = [
				highest_product_of_three,
				current * highest_product_of_2,
				current * lowest_product_of_2
			].max

			# do we have a new highest product of two?
			highest_product_of_2 = [
				highest_product_of_2,
				current * highest,
				current * lowest
			].max

			# do we have a new lowest product of two?
			lowest_product_of_2 = [
				lowest_product_of_2,
				current * highest,
				current * lowest
			].min

			# do we have a new highest?
			highest = [highest, current].max

			# do we have a new lowest?
			lowest = [lowest, current].min
		end

		return highest_product_of_three
	end
end

Gnuplot.open do |gp|
	Gnuplot::Plot.new( gp ) do |plot|

		plot.title  "mine vs theirs"
		plot.ylabel "execution time (real, seconds)"
		plot.xlabel "input size"

		x = (0..100000).step(1000).to_a

		y = x.collect do |v|
			array = (0..v - 1).to_a.shuffle
			Benchmark.measure { array.mine }.real
		end

		plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
			ds.with = "linespoints"
			ds.title = "mine"
		end

		b = x.collect do |v|
			array = (0..v - 1).to_a.shuffle
			Benchmark.measure { array.theirs }.real
		end

		plot.data << Gnuplot::DataSet.new( [x, b] ) do |ds|
			ds.with = "linespoints"
			ds.title = "theirs"
		end
	end
end

