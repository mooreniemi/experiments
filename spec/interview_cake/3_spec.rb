require 'spec_helper'

def attempt_one(array)
  array.max(3) { |a, b| a.abs <=> b.abs }.reduce(1, :*)
end

def answer(array)
  lowest, highest = array[0..1].minmax
  highest_product_of_2 = array[0] * array[1]
  lowest_product_of_2 = highest_product_of_2

  highest_product_of_3 = highest_product_of_2 * array[2]

  array[2..-1].each do |current|
    highest_product_of_3 = [
      highest_product_of_3,
      highest_product_of_2 * current,
      lowest_product_of_2 * current
    ].max

    highest_product_of_2 = [
      highest_product_of_2,
      current * highest,
      current * lowest
    ].max

    lowest_product_of_2 = [
      lowest_product_of_2,
      current * highest,
      current * lowest
    ].min

    highest = [highest, current].max
    lowest = [lowest, current].max
  end

  highest_product_of_3
end

# https://www.interviewcake.com/question/ruby/highest-product-of-3
describe 'Given an array of integers, find the highest product you can get from three of the integers.' do
  let(:array_one) { [-10, -10, 1, 3, 2] }
  let(:special_case) { [999, -1000, 998, 997] }

  it 'passes special case while  attempt_one does not' do
    expect(attempt_one(special_case)).to_not eq(994010994)
    expect(answer(special_case)).to eq(994010994)
  end

  it 'returns 300 even when non-unique negatives are used' do
    expect(attempt_one(array_one)).to eq(300)
    expect(answer(array_one)).to eq(300)
  end
end
