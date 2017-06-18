require 'spec_helper'

def coins(denoms, target)
  table = Array.new(target) { 0 }
  # base case, 1 way to make 0
  table.unshift(1)

  denoms.each_with_index do |denom, i|
    denom.upto(target) do |j|
      p table
      table[j] += table[j-denoms[i]]
    end
  end

  table[target]
end

describe 'find all ways to make change' do
  it 'there are 5 ways to make 10' do
    expect(coins([2, 5, 3, 6], 10)).to eq(5)
  end
  it 'there are 4 ways to make make 4' do
    expect(coins([1, 2, 3], 4)).to eq(4)
  end
end
