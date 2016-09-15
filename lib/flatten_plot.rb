require 'gnuplot'
require 'benchmark'

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|

    plot.title  "flatten performance"
    plot.ylabel "nesting amount"
    plot.xlabel "execution time"

    x = (0..10000).step(1000).to_a

    y = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.flatten.compact }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flatten+compact"
    end

    b = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.flat_map {|e| e unless e.nil? } }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, b] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flat_map"
    end

    c = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.flatten }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, c] ) do |ds|
      ds.with = "linespoints"
      ds.title = "only flatten"
    end
  end
end
