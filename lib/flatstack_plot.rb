require 'gnuplot'
require 'benchmark'
require 'benchmark-memory'

class Array
  def flat_stack
    flat = []
    stack = [] << self

    until stack.empty?
      e = stack.pop

      e.each do |a|
        if a.is_a? Array
          stack << a
        else
          flat << a
        end
      end
    end

    flat
  end
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|

    plot.title  "flatten performance"
    plot.ylabel "nesting amount"
    plot.xlabel "execution time"

    x = (0..10000).step(1000).to_a

    y = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.flat_stack }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flat_stack"
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

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|

    plot.title  "flatten memory"
    plot.ylabel "nesting amount"
    plot.xlabel "memory amount"

    x = (0..10000).step(1000).to_a

    z = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.memory {|r| r.report("flat_stack") { a.flatten.compact }}.entries.first.measurement.memory.allocated
    end

    plot.data << Gnuplot::DataSet.new( [x, z] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flat_stack memory"
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
