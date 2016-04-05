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
  attr_accessor :as_rows

  def initialize(value: nil, left: nil, right: nil)
    @value = value
    @left = left
    @right = right
    @as_rows = []
    default_breadth_properties
  end

  def children
    [left, right]
  end

  def bfs_for(element)
    self.distance = 0
    root = self
    queue = [root]
    visited = []

    until queue.empty?
      current = queue.shift
      adjacency_list = current.children

      adjacency_list.each do |node|
        root.as_rows << (node.nil? ? "x" : node.value)
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
