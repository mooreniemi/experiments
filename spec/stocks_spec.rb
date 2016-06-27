require 'spec_helper'
def get_max_profit_best(stock_prices_yesterday)

	# make sure we have at least 2 prices
	if stock_prices_yesterday.length < 2
		raise IndexError, 'Getting a profit requires at least 2 prices'
	end

	# we'll greedily update min_price and max_profit, so we initialize
	# them to the first price and the first possible profit
	min_price = stock_prices_yesterday[0]
	max_profit = stock_prices_yesterday[1] - stock_prices_yesterday[0]

	stock_prices_yesterday.each_with_index do |current_price, index|

		# skip the first time, since we already used it
		# when we initialized min_price and max_profit
		if index == 0 then next end

		# see what our profit would be if we bought at the
		# min price and sold at the current price
		potential_profit = current_price - min_price

		# update max_profit if we can do better
		max_profit = [max_profit, potential_profit].max

		# update min_price so it's always
		# the lowest price we've seen so far
		min_price  = [min_price, current_price].min
	end

	return max_profit
end

def get_max_profit(stocks)
	min_price = stocks[0]
	max_profit =  stocks[1] -  min_price

	stocks[1..-1].each do |stock|
		candidate_profit = stock - min_price
		max_profit = [max_profit, candidate_profit].max
		min_price = [min_price, stock].min
	end

	max_profit
end

# https://www.interviewcake.com/question/ruby/stock-price
describe "#get_max_profit(array)" do
	let(:good_stocks) { [10, 7, 5, 8, 11, 9] }
	let(:bad_stocks) { (0..10).to_a.reverse }
	let(:more_stocks) { [4, 2, 6, 6] }

	it 'gives the best diff given time constraint' do
		expect(get_max_profit(good_stocks)).to eq(6)
		expect(get_max_profit(more_stocks)).to eq(4)
	end
	it 'works with negatives' do
		expect(get_max_profit(bad_stocks)).to eq(-1)
	end
	it 'works the same as the real answer' do
		expect(get_max_profit(good_stocks)).to eq(get_max_profit_best(good_stocks))
	end
end
