require 'pry'

# https://www.careercup.com/question?id=5749533368647680
# Given the root of a binary tree containing integers, print the columns of the tree in order with the nodes in each column printed top-to-bottom.

class Node
  attr_accessor :left
  attr_accessor :right
  attr_accessor :value

  def initialize(value: nil, left: nil, right: nil)
    @value = value
    @left = left
    @right = right
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

  def postorder
  end
end

require 'tree_data'
include TreeData

describe "Tree" do
  describe "#preorder" do
    it 'outputs values' do
      expect{ fb_tree.preorder }.to output("6\n3\n5\n9\n2\n7\n1\n4\n0\n8\n").to_stdout
    end
  end
end
