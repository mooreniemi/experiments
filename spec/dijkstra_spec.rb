require 'spec_helper'

class Node
  attr_reader :value, :adj_list
  attr_accessor :parent, :distance

  def initialize(value)
    @value = value
    @parent = nil
    @distance = Float::INFINITY
    @adj_list = []
  end
end

Graph = Struct.new(:nodes) do
  def breadth_traversal
    nodes.first.distance = 0
    q = [nodes.first]

    until q.empty?
      (current = q.shift).adj_list.each do |n|
        next unless n.distance == Float::INFINITY
        n.distance = current.distance + 1
        n.parent = current
        q.unshift(n)
      end
    end

    self
  end
end

one = Node.new(1)
two = Node.new(2)
three = Node.new(3)
four = Node.new(4)
five = Node.new(5)

one.adj_list << two << three
two.adj_list << one
three.adj_list << one << four
four.adj_list << three << five
five.adj_list << four

describe "Dijkstra's Algorithm" do
  let(:graph) { Graph.new([one, two, three, four, five]) }
  it '#breadth_traversal assigns distances correctly' do
    traversed = graph.breadth_traversal
    (1..5).zip([0, 1, 1, 2, 3]).each do |pair|
      node = traversed.nodes.select { |n| n if n.value == pair[0] }.first
      expect(node.distance).to eq(pair[1])
    end
  end
end
