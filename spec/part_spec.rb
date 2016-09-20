require 'spec_helper'
# http://blog.klipse.tech/clojure/2016/09/16/combinatorics-riddle.html

def maximal_three_part(range)
  a = range.to_a
  perms = a.permutation.to_a
  maximal = 0
  highest_perms = nil
  perms.each do |p|
    a, b, c, d, e, f = p
    candidate = ((a * 100) + (b * 10) + c) *
      ((d * 10) + e) * f
    if candidate > maximal
      maximal = candidate
      highest_perms = p
    end
  end

  [maximal, highest_perms]
end

describe '#maximal_three_part' do
  it 'gets maximal product of partitioned digits' do
    expect(maximal_three_part(1..6)).to eq([134_472, [4, 3, 1, 5, 2, 6]])
  end
end
