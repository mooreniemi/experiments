require 'gnuplot'
require 'benchmark'
require 'benchmark-memory'
require 'array_collapse'

class Array
  def flat_stack(keep_nil = true)
    flat = []
    stack = [] << self

    until stack.empty?
      e = stack.pop

      e.each do |a|
        if a.is_a? Array
          stack << a
        else
          a = yield a if block_given?
          if keep_nil
            flat << a
          else
            flat << a unless a.nil?
          end
        end
      end
    end

    flat
  end
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|

    plot.title  "flatten performance"
    plot.xlabel "nesting amount"
    plot.ylabel "execution time"

    x = (0..10000).step(1000).to_a

    y = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.flat_stack {|e| e.nil? ? e : e + 1} }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flatstack(true) block"
    end

    c = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.flatten.map {|e| e.nil? ? e : e + 1} }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, c] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flatten+map"
    end

    d = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.measure { a.collapse {|e| e.nil? ? e : e + 1} }.real
    end

    plot.data << Gnuplot::DataSet.new( [x, d] ) do |ds|
      ds.with = "linespoints"
      ds.title = "collapse"
    end
  end
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|

    plot.title  "flatten memory"
    plot.ylabel "memory amount"
    plot.xlabel "nesting amount"

    x = (0..10000).step(1000).to_a

    z = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.memory {|r| r.report("collapse") { a.collapse }}.entries.first.measurement.memory.allocated
    end

    plot.data << Gnuplot::DataSet.new( [x, z] ) do |ds|
      ds.with = "linespoints"
      ds.title = "collapse"
    end

    d = x.collect do |v|
      a = Array.new(v,[v]<<[v]*v)
      Benchmark.memory {|r| r.report("flatten") { a.flatten }}.entries.first.measurement.memory.allocated
    end

    plot.data << Gnuplot::DataSet.new( [x, d] ) do |ds|
      ds.with = "linespoints"
      ds.title = "flatten"
    end
  end
end
