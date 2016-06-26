require 'gnuplot'
require 'benchmark'

# http://www.codequizzes.com/computer-science/big-o-algorithms
def combine(a, b)
	n = a.size
	result = Array.new(n * b.size)
	a.each do |i|
		b.each do |j|
			# result << [i, j]
			# result[(n * j) + i] = [i,j]
			result[(n * j) + i] = i
		end
	end
	result
end

# https://www.sitepoint.com/sorting-algorithms-ruby/
def bubble_sort(array)
  n = array.length
  loop do
    swapped = false

    (n-1).times do |i|
      if array[i] > array[i+1]
        array[i], array[i+1] = array[i+1], array[i]
        swapped = true
      end
    end

    break if not swapped
  end

  array
end

Gnuplot.open do |gp|
	Gnuplot::Plot.new( gp ) do |plot|

		plot.title  "combine(a,b) vs bubble_sort(a)"
		plot.ylabel "input size"
		plot.xlabel "execution time"

		x = (0..10000).step(1000).to_a

		y = x.collect do |v|
			array = (0..v - 1).to_a
			Benchmark.measure { combine(array,array) }.real
		end

		plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
			ds.with = "linespoints"
			ds.title = "combine"
		end

		b = x.collect do |v|
			shuffled = (0..v - 1).to_a.shuffle
      Benchmark.measure { bubble_sort(shuffled) }.real
    end

		plot.data << Gnuplot::DataSet.new( [x, b] ) do |ds|
			ds.with = "linespoints"
			ds.title = "bubble"
		end
	end
end
