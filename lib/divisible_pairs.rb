# https://www.reddit.com/r/ruby/comments/55bfhm/whats_the_ruby_way_to_solve_this_problem/
# https://www.hackerrank.com/challenges/divisible-sum-pairs
require 'graph/function'

Graph::Function.as_gif(File.expand_path('../divisible_pairs.gif', __FILE__))

tiny_int_generator = proc {|size| Array.new(size) { rand(-9...9) } }
comparison = Graph::Function::Comparison.new(tiny_int_generator)

def using_combination(a)
  a.combination(2).count { |ai, aj| (ai+aj) % 3 == 0 }
end

def using_while(a)
  count = 0
  i = 0

  while i < a.length
    j = i + 1
    while j < a.length
      if (a[i] + a[j]) % 3 == 0
        count = count + 1
      end

      j += 1
    end

    i += 1
  end
end


comparison.of(method(:using_combination), method(:using_while))
