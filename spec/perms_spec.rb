require 'spec_helper'

def perms(str)
  return [str] if str.length == 1
  results = []
  str.length.times do |i|
    substring = str.dup
    c = substring.slice!(i - 1)
    perms(substring).map do |s|
      results << c + s
    end
  end
  results
end

RSpec.describe '#perms' do
  it 'returns permutations' do
    expect(perms('abc')).to match_array(
      %w(abc bac cba cab bca acb)
    )
  end
end
