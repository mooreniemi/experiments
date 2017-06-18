#!/usr/bin/ruby

require 'benchmark'

puts "Running Ruby #{RUBY_VERSION}"

ary = Array.new(1000) do
	{
		foo: 'foo',
		bar: rand(1000)
  }
end

n = 500

puts "n=#{n}"
Benchmark.bm(20) do |x|
	x.report("sort")               { n.times { ary.dup.sort{ |a,b| b[:bar] <=> a[:bar] } } }
	x.report("sort reverse")       { n.times { ary.dup.sort{ |a,b| a[:bar] <=> b[:bar] }.reverse } }
	x.report("sort reverse!")       { n.times { ary.dup.sort{ |a,b| a[:bar] <=> b[:bar] }.reverse! } }
	x.report("sort_by -a[:bar]")   { n.times { ary.dup.sort_by{ |a| -a[:bar] } } }
	x.report("sort_by a[:bar]*-1") { n.times { ary.dup.sort_by{ |a| a[:bar]*-1 } } }
	x.report("sort_by.reverse")    { n.times { ary.dup.sort_by{ |a| a[:bar] }.reverse } }
	x.report("sort_by.reverse!")   { n.times { ary.dup.sort_by{ |a| a[:bar] }.reverse! } }
end
