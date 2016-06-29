require 'gnuplot'
require 'benchmark'

class Array
  def quadratic
    # doesnt work for duplicates
    self.map {|e| (self - [e]).reduce(1, :*)}
  end

  def linear
    n = self.size
    products = []

    accumulated_product, i = 1, 0
    while i < n
      products[i] = accumulated_product
      accumulated_product *= self[i]
      i += 1
    end

    accumulated_product, i = 1, (n - 1)
    while i >= 0
      products[i] *= accumulated_product
      accumulated_product *= self[i]
      i -= 1
    end

    products
  end
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|

    plot.title  "quadratic vs linear (products of all other numbers)"
    plot.ylabel "execution time (real, seconds)"
    plot.xlabel "input size"

    x = (0..10000).step(1000).to_a

    y = x.collect do |v|
      array = (0..v - 1).to_a
      Benchmark.measure { array.quadratic }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "linespoints"
      ds.title = "quadratic"
    end

    b = x.collect do |v|
      array = (0..v - 1).to_a
      Benchmark.measure { array.linear }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, b] ) do |ds|
      ds.with = "linespoints"
      ds.title = "linear"
    end
  end
end
