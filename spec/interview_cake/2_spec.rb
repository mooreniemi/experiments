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

MULTIPLICATIVE_IDENTITY = 1
def except_self3(nums)
  prods = []

  prod = MULTIPLICATIVE_IDENTITY
  nums.size.times do |i|
    prods[i] = prod
    prod *= nums[i]
  end

  prod = MULTIPLICATIVE_IDENTITY
  (nums.size - 1).downto(0) do |i|
    prods[i] *= prod
    prod *= nums[i]
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
    expect(except_self3(arr)).to eq([84,12,28,21])
  end
end

require 'graph/function'
Graph::Function.configure do |config|
  config.terminal = 'gif'
  config.output = File.expand_path('../comparing_ints.gif', __FILE__)
  config.step = (0..100).step(10).to_a # default value
  config.trials = 10
end
Graph::Function::IntsComparison.of(method(:except_self2), method(:except_self3))
