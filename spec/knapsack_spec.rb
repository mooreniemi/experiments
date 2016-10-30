require 'spec_helper'

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
    fail 'Knapsack overcapacity!' if current_weight + added_weight > 4

    super
  end
end

class Thief
  attr_accessor :knapsack

  def initialize
    @knapsack = Knapsack.new
  end

  def steal_optimally_from(house)
    # prepopulate our table with each good
    table = house.posessions.each_with_object([]) do |e, a|
      a << [e] * 4
    end

    # each row is a Good, and each column a price per weight
    1.upto(house.posessions.size - 1) do |row|
      table[row].each_with_index do |good, column|
        # adjusted because we're 0-indexed
        weight_limit = column + 1

        # make sure this Good fits, and if not, grab previous
        if good.weight > weight_limit
          table[row][column] = table[row-1][column]
          next
        end

        # now we know this Good fits, but does it fill this slot?
        remaining_weight = weight_limit - good.weight
        if remaining_weight > 0
          previous_good = table[row-1][remaining_weight]
        else
          previous_good = nil
        end
        newly_combined_goods = [good, previous_good]

        sum_prices_of = proc { |a| a.flatten.compact.map(&:price).reduce(0, :+) }
        newly_combined_goods_price = sum_prices_of.(newly_combined_goods)
        current_good_price = good.is_a?(Array) ? sum_prices_of.(good) : good.price

        if newly_combined_goods_price > current_good_price
          table[row][column] = newly_combined_goods
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
  let(:house) { House.new([guitar, stereo, laptop]) }
  let(:thief) { Thief.new }

  it 'has a Knapsack (container of Goods) with a 4lb maximum' do
    expect{ Knapsack.new << 2 }.
      to raise_error('2 must be a Good to go in Knapsack')
    expect{ Knapsack.new << stereo << laptop }.
      to raise_error('Knapsack overcapacity!')
    expect(Knapsack.new << guitar << laptop).to be_a(Knapsack)
  end

  it 'maximizes price by weight in stealing' do
    expect(thief.steal_optimally_from(house).knapsack).
      to match_array([guitar, laptop])
  end
end
