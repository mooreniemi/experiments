require 'spec_helper'

MERGE = proc do |a, b|
  c = []
  c << (a.first > b.first ? b.shift : a.shift) until a.empty? || b.empty?
  c << a.shift until a.empty?
  c << b.shift until b.empty?
  c
end

class Array
  def halve
    [take(pivot = (size / 2.0).round), drop(pivot)]
  end
end

def merge_sort(array)
  return array if array.size == 1

  left, right = array.halve
  first_half = merge_sort(left)
  second_half = merge_sort(right)

  MERGE.call(first_half, second_half)
end

# http://www.algorithmist.com/index.php/Merge_sort#Pseudo-code
describe 'merge_sort' do
  context 'relies on' do
    it 'MERGE proc' do
      expect(MERGE.call([1], [2])).to match_array([1, 2])
      expect(MERGE.call([2], [1])).to match_array([1, 2])
    end
    it '#halve-ing an Array' do
      expect([1, 2].halve).to eq([[1], [2]])
      expect([1, 2, 3].halve).to eq([[1, 2], [3]])
      expect([1, 2, 3, 4].halve).to eq([[1, 2], [3, 4]])
    end
  end
  it 'sorts an Array' do
    expect(merge_sort([13, 2])).to eq([2, 13])
    expect(merge_sort([13, 2, 5, 1, 22])).to eq([1, 2, 5, 13, 22])
  end
end
