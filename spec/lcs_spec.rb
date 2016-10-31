require 'spec_helper'

class String
  def lcs(other_string)
    return 0 if self.length.zero? || other_string.length.zero?
    longer_string_length = (self.length > other_string.length ? self : other_string).length
    table = [[0] * longer_string_length] * longer_string_length

    self.each_char.with_index(0) do |first_char,i|
      other_string.each_char.with_index(0) do |second_char,j|
        if first_char == second_char
          table[i][j] = table[i-1][j-1] + 1
          # we dont need an else because we prepopulated :)
        end
      end
    end

    table.flatten.max
  end
end

describe 'Longest Common Subsequence' do
  it 'operates between Strings to return an Int' do
    expect(''.lcs('')).to eq(0)
  end
  it 'returns 0 if char does not match' do
    expect('a'.lcs('b')).to eq(0)
  end
  it 'returns 1 if char does match' do
    expect('a'.lcs('a')).to eq(1)
  end
  it 'accumulates if sequence continues' do
    expect('ab'.lcs('ab')).to eq(2)
  end
  it 'passes tutorialhorizon spec' do
    one = 'tutorialhorizon'
    two = 'dynamictutorialProgramming'
    expect(one.lcs(two)).to eq(8)
  end
end
