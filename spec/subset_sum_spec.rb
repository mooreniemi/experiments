# http://www.skorks.com/2011/02/algorithms-a-dropbox-challenge-and-dynamic-programming/
require 'spec_helper'
require 'subset_sum'

describe 'subset sum' do
  using SubsetSum

  it 'returns 0 for empty array' do
    expect([].subset_sum_to(0)).to eq([])
  end

  it 'returns false when no subset satisfies' do
    pending
  end

  it 'returns the subset when one satisfies' do
    expect([1,-3,2,4].subset_sum_to(0)).to eq([-3,1,2])
  end
end
