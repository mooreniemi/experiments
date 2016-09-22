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

  def to_s
    [value, distance]
  end
end

class WeightedNode < Node
  attr_accessor :edge_list
  def initialize(value)
    @edge_list = {}
    super
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

  require 'pqueue'
  def dijkstra
    nodes.first.distance = 0
    pq = PQueue.new(nodes) { |a, b| a.distance < b.distance }

    until pq.empty?
      (current = pq.pop).edge_list.keys.each do |n|
        alt = current.distance + current.edge_list[n]
        if pq.include?(n) && alt < n.distance
          n.distance = alt
          n.parent = current
        end
      end
    end

    nodes.map(&:value).zip(nodes.map(&:distance))
  end

  def shortest_path(source, target)
    source.distance = 0
    pq = PQueue.new(nodes) { |a, b| a.distance < b.distance }
    path = []

    until pq.empty?
      (current = pq.pop).edge_list.keys.each do |n|
        if n == target
          u = n
          until u.parent.nil?
            path << u.to_s unless path.include? u.to_s
            u = u.parent
          end
        end

        alt = current.distance + current.edge_list[n]
        if pq.include?(n) && alt < n.distance
          n.distance = alt
          n.parent = current
        end
      end
    end

    path
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

wone = WeightedNode.new(1)
wtwo = WeightedNode.new(2)
wthree = WeightedNode.new(3)
wfour = WeightedNode.new(4)

wone.edge_list[wtwo] = 4
wtwo.edge_list[wone] = 4
wtwo.edge_list[wthree] = 2
wthree.edge_list[wtwo] = 2
wthree.edge_list[wfour] = 3
wfour.edge_list[wthree] = 3
wfour.edge_list[wone] = 1
wone.edge_list[wfour] = 1

describe "Dijkstra's Algorithm" do
  context 'for reference, simple BFS' do
    let(:graph) { Graph.new([one, two, three, four, five]) }
    it '#breadth_traversal assigns distances correctly' do
      traversed = graph.breadth_traversal
      (1..5).zip([0, 1, 1, 2, 3]).each do |pair|
        node = traversed.nodes.select { |n| n if n.value == pair[0] }.first
        expect(node.distance).to eq(pair[1])
      end
    end
  end
  context '#dijkstra' do
    let(:graph) { Graph.new([wone, wtwo, wthree, wfour]) }
    it 'gives shortest distance' do
      expect(graph.dijkstra).to eq([[1, 0], [2, 4], [3, 4], [4, 1]])
    end
    describe '#shortest_path(source, target)' do
      it 'returns shortest path' do
        expect(graph.shortest_path(wone, wthree)).to eq([[3, 4], [4, 1]])
      end
    end
  end
end
