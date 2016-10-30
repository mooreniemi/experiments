require 'spec_helper'

# An exercise drawn from Grokking Algorithms, chapter 9 (pg. 162)
# https://www.manning.com/books/grokking-algorithms

KNAPSACK_CAPACITY = 4

class Good
  attr_accessor :weight, :price, :kind
  def initialize(w, p, k)
    @weight = w
    @price = p
    @kind = k
  end
end

class Knapsack < Array
  def <<(e)
    fail "#{e} must be a Good to go in Knapsack" unless e.is_a? Good

    added_weight = e.weight
    current_weight = self.map(&:weight).reduce(0, :+)
    fail 'Knapsack overcapacity!' if current_weight + added_weight > KNAPSACK_CAPACITY

    super
  end
end

class Thief
  attr_accessor :knapsack

  def initialize
    @knapsack = Knapsack.new
  end

  def steal_optimally_from(house)
    # prepopulate our table with each Good
    table = house.posessions.each_with_object([]) do |e, a|
      a << [e] * KNAPSACK_CAPACITY
    end

    # we can skip the first row, because we pre-populated
    1.upto(house.posessions.size - 1) do |row|
      # each Good gets its own row, and each column is a #weight capacity ('slot')
      table[row].each_with_index do |good, column|
        # adjusted because we're 0-indexed in an Array
        weight_limit = column + 1

        # make sure this Good fits, and if not, grab previous
        # we could make this step a no-op if we prepopulate differently
        if good.weight > weight_limit
          table[row][column] = table[row-1][column]
          next
        end

        # now we know this Good fits, but does it fill this slot?
        remaining_weight = weight_limit - good.weight
        if remaining_weight > 0
          previous_good = table[row-1][remaining_weight-1]
        else
          previous_good = nil
        end
        newly_combined_goods = [good, previous_good]

        # if the slot wasn't full, we filled the remaining #weight,
        # so let's compare that to just this current Good's #price
        sum_prices_of = proc { |a| a.flatten.compact.map(&:price).reduce(0, :+) }
        newly_combined_goods_price = sum_prices_of.(newly_combined_goods)
        # we have to account for Array here because we might already be a combo
        current_good_price = good.is_a?(Array) ? sum_prices_of.(good) : good.price

        if newly_combined_goods_price > current_good_price
          table[row][column] = newly_combined_goods.flatten
        else
          table[row][column] = good
        end
      end
    end

    # our best option will be in the bottom rightmost entry
    table.last.last.each do |g|
      knapsack << g
    end

    self
  end
end

class House
  attr_accessor :posessions

  def initialize(p)
    @posessions = p
  end
end

describe 'a Thief in the night' do
  let(:guitar) { Good.new(1,15,'guitar') }
  let(:stereo) { Good.new(4,30,'stereo') }
  let(:laptop) { Good.new(3,20,'laptop') }
  let(:iphone) { Good.new(1,20,'iphone') }

  let(:house) { House.new([guitar, stereo, laptop]) }
  let(:house_with_iphone) { House.new([guitar, stereo, laptop, iphone]) }
  let(:thief) { Thief.new }

  it 'has a Knapsack (container of Goods) with a 4lb maximum' do
    expect{ Knapsack.new << 2 }.
      to raise_error('2 must be a Good to go in Knapsack')
    expect{ Knapsack.new << stereo << laptop }.
      to raise_error('Knapsack overcapacity!')
    expect(Knapsack.new << guitar << laptop).to be_a(Knapsack)
  end

  it 'will #steal_optimally_from(House)' do
    expect(thief.steal_optimally_from(house).knapsack).
      to match_array([guitar, laptop])
  end

  it 'definitely grabs your iPhone, too' do
    expect(thief.steal_optimally_from(house_with_iphone).knapsack).
      to match_array([iphone, laptop])
  end
end
