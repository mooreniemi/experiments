require 'spec_helper'
require 'subset_sum'

describe 'subset sum' do
  using SubsetSum

  it 'returns 0 for empty array' do
    expect([].subset_sum_to(0)).to eq([])
  end

  it 'returns false when no subset satisfies' do
  end

  it 'returns the subset when one satisfies' do
    expect([-3,1,2, 4].subset_sum_to(0))
  end
end
