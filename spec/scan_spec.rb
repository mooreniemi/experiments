require 'spec_helper'

class Array
  def scanl accumulator, &block
    results = [accumulator] + self
    results.each_with_index do |e, i|
      results[i] = block.call(accumulator, e)
      accumulator = results[i]
    end
    results
  end
  def scanr accumulator, &block
    results = self + [accumulator]
    n = results.size
    (n - 1).downto(0) do |i|
      results[i] = block.call(accumulator, results[i])
      accumulator = results[i]
    end
    results
  end
end

describe "#scanl" do
  it 'is similar to foldl, but returns a list of successive reduced values from the left' do
    # example from http://learnyouahaskell.com/higher-order-functions
    expect([3, 5, 2, 1].scanl(0, &:+)).to eq([0,3,8,10,11])
  end
end

describe "#scanr" do
  it 'report all the intermediate accumulator states in the form of a list from right' do
    expect([3, 5, 2, 1].scanr(0, &:+)).to eq([11,8,3,1,0])
  end
end
