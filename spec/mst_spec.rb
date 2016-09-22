require 'spec_helper'

class Node
  attr_reader :value
  attr_accessor :parent
  attr_accessor :distance

  def initialize(value)
    @value = value
    @parent = nil
    @distance = Float::INFINITY
  end
end

class WeightedNode < Node
  attr_accessor :weight

  def initialize(value)
    @weight = {}
    super
  end

  def neighbors
    weight.keys
  end
end

Graph = Struct.new(:nodes) do
  require 'pqueue'
  def prim
    nodes.first.distance = 0
    pq = PQueue.new(nodes) { |a, b| a.distance < b.distance }

    until pq.empty?
      (current = pq.pop).neighbors.each do |n|
        if pq.include?(n) && (c_to_n = current.weight[n]) < n.distance
          n.parent = current
          n.distance = c_to_n
        end
      end
    end

    nodes.map(&:value).zip(nodes.map(&:distance))
  end
  def dijkstra
    nodes.first.distance = 0
    pq = PQueue.new(nodes) { |a, b| a.distance < b.distance }

    until pq.empty?
      (current = pq.pop).neighbors.each do |n|
        alt = current.distance + current.weight[n]
        if pq.include?(n) && alt < n.distance
          n.distance = alt
          n.parent = current
        end
      end
    end

    nodes.map(&:value).zip(nodes.map(&:distance))
  end
end

one, two, three, four = Array.new(4) { |i| WeightedNode.new(i+1) }

one.weight[two] = 5
two.weight[one] = 5

one.weight[three] = 5
three.weight[one] = 5

one.weight[four] = 5
four.weight[one] = 5

two.weight[four] = 1
four.weight[two] = 1

three.weight[four] = 1
four.weight[three] = 1

describe Graph do
  let(:g) { Graph.new([one, two, three, four]) }
  # http://stackoverflow.com/a/20482220/1791856
  describe '#prim' do
    it 'returns correct distance' do
      expect(g.prim.map(&:last).reduce(0,:+)).to eq(7)
    end
  end

  describe '#dijkstra' do
    it 'returns correct distance' do
      # have to reset the distances
      one.distance = Float::INFINITY
      two.distance = Float::INFINITY
      three.distance = Float::INFINITY
      four.distance = Float::INFINITY
      expect(g.dijkstra.map(&:last).reduce(0,:+)).to eq(15)
    end
  end
end
