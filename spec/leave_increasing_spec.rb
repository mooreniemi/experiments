require 'spec_helper'

def longest_sub_n2(array)
  cache = {}
  array.each do |e|
    cache[e] = [e]
  end

  array.each_with_index do |e, i|
    array[(i+1)..-1].each do |f|
      cache[e] << f if f > cache[e].last
    end
  end

  cache.values.max_by(&:size)
end

def better_longest_sub(array)
  cache = {}
  array.each do |e|
    cache[e] = [e]
  end

  smallest = [array[0]]
  array[1..-1].each do |e|
    smallest << e if e < smallest.last
    smallest.each do |f|
      cache[f] << e if e > cache[f].last
    end
  end

  cache.values.max_by(&:size)
end

# version translated from cpp https://www.hackerrank.com/challenges/longest-increasing-subsequent
def lis(array)
  cache = Array.new(array.size) { [] }

  array.each_with_index do |current_element, current_index|
    0.upto(current_index - 1) do |previous_index|
      greater_element = array[previous_index] < current_element
      decreasing = cache[current_index].size < (cache[previous_index].size+1)

      if greater_element && decreasing
        cache[current_index] = cache[previous_index].dup
      end
    end

    p cache
    cache[current_index] << current_element
  end

  cache.max_by(&:size)
end

describe 'find longest increasing subarray' do
  let(:array_one) { [1, 2, 0] }
  let(:array_with_duplicates) { [1, 1, 2, 0] }
  let(:mit_array) { [3, 2, 6, 4, 5, 1]}
  let(:array_three) { [0, 2, 1, 2] }
  let(:array_two) { [23, 22, 4, 9, 3, 0, 1, 2, 6] }
  context 'wrong without DP' do
    describe '#longest_sub_n2' do
      it 'handles duplicates' do
        expect(longest_sub_n2(array_with_duplicates)).to eq([1, 2])
      end
      it "[1, 2, 0]" do
        expect(longest_sub_n2(array_one)).to eq([1, 2])
      end
      it "[23, 22, 4, 9, 3, 0, 1, 2, 6]" do
        expect(longest_sub_n2(array_two)).to eq([0, 1, 2, 6])
      end
    end
    describe '#better_longest_sub' do
      it "[1, 2, 0]" do
        expect(better_longest_sub(array_one)).to eq([1, 2])
      end
      it "[23, 22, 4, 9, 3, 0, 1, 2, 6]" do
        expect(better_longest_sub(array_two)).to eq([0, 1, 2, 6])
      end
    end
  end
  context 'needs DP' do
    describe '#lis' do
      it 'handles duplicates' do
        #expect(lis(array_one)).to eq([1, 2])
        #expect(lis(array_two)).to eq([0, 1, 2, 6])
        expect(lis(mit_array)).to eq([2, 4, 5])
        expect(lis(array_three)).to eq([0, 1, 2])
        #expect(lis(array_with_duplicates)).to eq([1, 2])
      end
    end
  end
end
