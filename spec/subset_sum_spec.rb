# http://www.skorks.com/2011/02/algorithms-a-dropbox-challenge-and-dynamic-programming/
require 'spec_helper'
require 'rantly/rspec_extensions'    # for RSpec
require 'rantly/shrinks'
require 'subset_sum'

describe 'subset sum' do
  using SubsetSum

  it 'returns 0 for empty array' do
    expect([].subset_sum_to(0)).to eq([])
  end

  it 'returns false when no subset satisfies' do
    expect([2,3].subset_sum_to(6)).to eq(false)
  end

  it 'returns the subset when one satisfies' do
    expect([2,2].subset_sum_to(4).sort).to eq([2,2].sort)
    expect([1,-3,2,4].subset_sum_to(0).sort).to eq([2,-3,1].sort)
    expect([1,2,3,4].subset_sum_to(6).sort).to eq([1,2,3].sort)
    expect([1,2,3,4,5].subset_sum_to(6).sort).to eq([1,2,3].sort)
    expect([1,2,3,4,5,5].subset_sum_to(10).sort).to eq([1,2,3,4].sort)
    expect([3,34,4,12,5,2].subset_sum_to(9).sort).to eq([4,5].sort)
  end

  context 'property-based testing' do
    it 'if target is sum of whole set, return set' do
      property_of {
        len = range(0, 10)
        # couldn't get this to load, docs out of date?
        # Deflating.new( array(len) { integer } )
        array(len) { range(1,25) }
      }.check {|array|
        expect(array.subset_sum_to(array.reduce(0,:+))).to match_array(array)
      }
    end
  end
end
