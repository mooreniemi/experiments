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
  array[1..-1].each_with_index do |e, _|
    smallest << e if e < smallest.last
    smallest.each do |f|
      cache[f] << e if e > cache[f].last
    end
  end

  cache.values.max_by(&:size)
end

describe 'find longest increasing subarray' do
  let(:array_one) { [1, 2, 0] }
  let(:array_with_duplicates) { [1, 1, 2, 0] }
  let(:array_three) { [0, 2, 1, 2] }
  let(:array_two) { [23, 22, 4, 9, 3, 0, 1, 2, 6] }
  describe '#longest_sub_n2' do
    it 'handles duplicates' do
      expect(longest_sub_n2(array_with_duplicates)).to eq([1, 2])
      expect(longest_sub_n2(array_three)).to eq([0, 1, 2])
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
