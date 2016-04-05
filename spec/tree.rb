require 'pry'

# https://www.careercup.com/question?id=5749533368647680
# Given the root of a binary tree containing integers, print the columns of the tree in order with the nodes in each column printed top-to-bottom.

module Breadth
  attr_accessor :distance
  attr_accessor :parent

  def default_breadth_properties
    @distance = Float::INFINITY
    @parent = nil
  end
end

class Node
  include Breadth

  attr_accessor :left
  attr_accessor :right
  attr_accessor :value

  def initialize(value: nil, left: nil, right: nil)
    @value = value
    @left = left
    @right = right
    default_breadth_properties
  end

  def children
    [left, right]
  end

  def bfs_for(element)
    self.distance = 0
    queue = [self]
    visited = []

    until queue.empty?
      current = queue.shift
      current.children.each do |node|
        next if node.nil?
        visited << node.value

        if node.distance == Float::INFINITY
          node.distance = current.distance + 1
          node.parent = current
          queue.push(node)
        end
      end
    end

    visited.include?(element)
  end

  def preorder(current = self)
    puts current.value
    preorder(current.left) unless current.left.nil?
    preorder(current.right) unless current.right.nil?
  end

  def inorder(current = self)
    puts inorder(current.left) unless current.left.nil?
    puts current.value
    puts inorder(current.right) unless current.right.nil?
  end

  def postorder(current = self)
    puts postorder(current.left) unless current.left.nil?
    puts postorder(current.right) unless current.right.nil?
    puts current.value
  end
end

require 'tree_data'
include TreeData

describe "Tree" do
  describe "#children" do
    it 'gives left and right together' do
      expect(fb_tree.children.size).to eq(2)
    end
  end
  describe "#preorder" do
    it 'outputs values' do
      # [ 6, 3, 5, 9, 2, 7, 1, 4, 0, 8 ]
      expect{ fb_tree.preorder }.to output("6\n3\n5\n9\n2\n7\n1\n4\n0\n8\n").to_stdout
    end
  end
  describe "#inorder" do
    it 'outputs values' do
      # [ 9, 5, 2, 7, 3, 1, 6, 4, 8, 0 ]
      expect{ fb_tree.inorder }.to output("9\n\n5\n2\n7\n\n\n\n3\n1\n\n\n6\n4\n8\n\n0\n\n\n").to_stdout
    end
  end
  describe "#postorder" do
    it 'outputs values' do
      # [ 9, 7, 2, 5, 1, 3, 8, 0, 4, 6 ]
      expect{ fb_tree.postorder }.to output("9\n\n7\n\n2\n\n5\n\n1\n\n3\n\n8\n\n0\n\n4\n\n6\n").to_stdout
    end
  end

  describe "columning" do
    # TODO non-coordinates strategy
    # bfs to get rows and height and keep placeholders
    # get max width based on height from bfs
    # pad all rows

    it 'requires BFS' do
      expect(fb_tree.bfs_for(7)).to be true
      expect(fb_tree.bfs_for(17)).to be false
    end

    it 'represents trees as levels' do
      top = [nil, nil, 6, nil, nil]
      middle = [nil, 3, nil, nil, 4, nil]
      bottom = [5, nil, 1, nil, nil, 0]

      first_column = [top[0]] + [middle[0]] + [bottom[0]]
      second_column = [top[2]] + [middle[2]] + [bottom[2]]
      expect(first_column).to eq([nil, nil, 5])
      expect(second_column).to eq([6, nil, 1])
    end
  end
end
