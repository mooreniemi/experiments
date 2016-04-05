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

  def postorder(current = self)
    puts postorder(current.left) unless current.left.nil?
    puts postorder(current.right) unless current.right.nil?
    puts current.value
  end
end

require 'tree_data'
include TreeData

describe "Tree" do
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
end
