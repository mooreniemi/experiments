require 'spec_helper'
require 'rantly/rspec_extensions'

def partition(array, left_bound, right_bound)
  pivot = array[left_bound] # ~ array.first
  i = left_bound + 1 # ~ array.second
  i.upto(right_bound - 1) do |j|
    if array[j] < pivot
      array[i], array[j] = array[j], array[i]
      i += 1
    end
  end
  array[i-1], array[left_bound] = array[left_bound], array[i-1]
  array
end

describe '#partition' do
  it 'partitions correctly' do
    expect(partition([3,4,2,1],0,4)).to eq([1,2,3,4])
  end
  describe 'property tests' do
    it 'puts pivot in correct sorted position' do
      property_of {
        array = array(10) { call([:range,0,10_000]) }
        pivot = array.first
        sorted = array.sort
        pivot_index = sorted.index(pivot)

        [pivot_index, pivot, array]
      }.check { |(pi,p,a)|
        partitioned = partition(a,0,a.length)
        partitioned_position = partitioned.index(p)

        expect(partitioned_position).to eq(pi)
      }
    end
    it 'left of pivot is LT, right of pivot is GT' do
      property_of {
        array(10) { call([:range,0,10_000]) }
      }.check { |a|
        pivot = a.first
        partitioned = partition(a,0,a.length)
        pivot_index = partitioned.index(pivot)
        expect(partitioned[0..pivot_index].all? { |e| e <= pivot}).to eq(true)
        expect(partitioned[pivot_index..-1].all? { |e| e >= pivot}).to eq(true)
      }
    end
  end
end
