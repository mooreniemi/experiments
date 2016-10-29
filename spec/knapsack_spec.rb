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
    fail 'Must be a Good to go in Knapsack' unless e.is_a? Good

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
      to raise_error('Must be a Good to go in Knapsack')
    expect{ Knapsack.new << stereo << laptop }.
      to raise_error('Knapsack overcapacity!')
    expect(Knapsack.new << guitar << laptop).to be_a(Knapsack)
  end

  it 'maximizes price by weight in stealing' do
    expect(thief.steal_optimally_from(house).knapsack).
      to include([guitar, laptop])
  end
end
