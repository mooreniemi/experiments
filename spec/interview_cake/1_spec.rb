require 'spec_helper'

def quadratic_get_max_profit(stocks)
  max_profit = -Float::INFINITY
  stocks.each_with_index do |e, i|
    stocks[i+1..-1].each do |f|
      max_profit = [
        max_profit,
        f - e
      ].max
    end
  end
  max_profit
end

def get_max_profit(stocks)
  lowest_price = stocks[0]
  max_profit = -Float::INFINITY

  stocks[1..-1].each do |stock|
    max_profit = [
      max_profit,
      stock - lowest_price
    ].max

    lowest_price = [
      lowest_price,
      stock
    ].min
  end

  max_profit
end

# https://www.interviewcake.com/question/ruby/stock-price
describe 'returns the best profit I could have made from 1 purchase and 1 sale of 1 Apple stock yesterday' do
  let(:stock_prices_yesterday) { [10, 7, 5, 8, 11, 9] }
  let(:down_all_day) { [10, 9, 8, 7, 6, 5] }
  let(:up_all_day) { [10, 9, 8, 7, 6, 5].reverse }

  it 'buys low and sells high' do
    expect(get_max_profit(stock_prices_yesterday)).to eq(6)
  end

  it 'deals with a bad day' do
    expect(get_max_profit(down_all_day)).to eq(-1)
  end

  it 'deals with a good day' do
    expect(get_max_profit(up_all_day)).to eq(5)
  end
end
