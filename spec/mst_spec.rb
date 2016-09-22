require 'spec_helper'

class Node
  attr_reader :value
  attr_accessor :adj_list, :parent
  attr_accessor :distance

  def initialize(value)
    @value = value
    @parent = nil
    @distance = Float::INFINITY
    @adj_list = []
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
  def minimum_span_tree
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
  describe '#minimum_span_tree' do
    it 'returns correct distance' do
      expect(g.minimum_span_tree.map(&:last).reduce(0,:+)).to eq(7)
    end
  end
end
