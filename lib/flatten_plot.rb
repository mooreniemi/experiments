require 'gnuplot'
require 'benchmark'
require 'benchmark-memory'

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

    z = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.memory {|r| r.report("flatten+compact") { a.flatten.compact }}.entries.first.measurement.memory.allocated
    end

    plot.data << Gnuplot::DataSet.new( [x, z] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flatten+compact memory"
    end

    c = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.flatten }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, c] ) do |ds|
      ds.with = "linespoints"
      ds.title = "only flatten"
    end

    d = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.memory {|r| r.report("flatten") { a.flatten }}.entries.first.measurement.memory.allocated
    end

    plot.data << Gnuplot::DataSet.new( [x, d] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flatten memory"
    end
  end
end
