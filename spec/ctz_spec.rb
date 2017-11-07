require 'spec_helper'

module CompareAbs
  refine Integer do
    def compare_abs(other)
      if self != other && self.abs == other.abs
        self.negative? ? 1 : -1
      else
        self.abs <=> other.abs
      end
    end
  end
end

using CompareAbs
ctz = ->(x) { x.min {|a,b| a.compare_abs(b) } }

describe 'closest to zero' do
  it 'returns 0 for [*,0,*]' do
    expect(ctz.([0])).to eq(0)
    expect(ctz.([0,-1,1])).to eq(0)
    expect(ctz.([-1,0,1,2])).to eq(0)
  end
  it 'returns 1 for [1,2] / [2,1]' do
    expect(ctz.([1,2])).to eq(1)
    expect(ctz.([2,1])).to eq(1)
  end
  it 'returns 1 for [1,-1] / [-1,1]' do
    expect(ctz.([1,-1])).to eq(1)
    expect(ctz.([-1,1])).to eq(1)
  end
end
