require 'spec_helper'

# NOTE: quadratic brute force with memoization
def except_self(a)
  prods = [1] * a.size
  memo = {}
  a.each_with_index do |_, i|
    a.each_with_index do |f, j|
      next if i == j
      prods[i] = memo.fetch("#{prods[i]} * #{f}") do |k|
        p "calculating (#{k})"
        memo[k] = eval(k)
      end
    end
  end
  prods
end

def except_self2(nums)
  prods = []
  (s = nums.size).times do |i|
    if i == 0
      prod_before = 1
    else
      prod_before = nums[0..i-1].reduce(1, :*)
    end
    prod_after = nums[i+1..s].reduce(1, :*)
    p "#{prod_before} * #{prod_after}"
    prods[i] = prod_before * prod_after
  end
  prods
end

describe 'product of other numbers' do
  let(:arr) { [1,7,3,4] }
  it 'doesnt double first element' do
    expect(except_self2([1,2])).to eq(except_self([1,2]))
  end
  it 'returns all but self' do
    expect(except_self(arr)).to eq([84,12,28,21])
    expect(except_self2(arr)).to eq([84,12,28,21])
  end
end
