module Heapify
  # TODO
  # https://en.wikipedia.org/wiki/Binary_heap#Insert
  def insert
    #Add the element to the bottom level of the heap.
    #Compare the added element with its parent; if they are in the correct order, stop.
    #If not, swap the element with its parent and return to the previous step.
  end
end

module Breadth
  attr_accessor :distance
  attr_accessor :parent
  attr_accessor :rows, :height

  def height
    @height ||= 0
  end

  def rows
    @rows ||= []
  end

  def as_rows
    rows_copy = with_rows_and_height.rows.dup
    rowed = []
    self.height.times do |n|
      if n == 1
        rowed << rows_copy.slice!(0..1)
      else
        rowed << rows_copy.slice!(0..2**n + 1)
      end
    end
    rowed
  end

  def distance
    @distance ||= Float::INFINITY
  end

  def parent
    @parent ||= nil
  end

  # same as BFS but returns receiver, just used
  # for its side-effect
  def with_rows_and_height
    root = self
    queue = [root]
    visited = []

    until queue.empty?
      current = queue.shift
      adjacency_list = current.children

      self.height += 1
      adjacency_list.each do |node|
        root.rows << (node.nil? ? "x" : node.value)
        next if node.nil?
        visited << node.value

        if node.distance == Float::INFINITY
          node.distance = current.distance + 1
          node.parent = current
          queue.push(node)
        end
      end
    end

    self
  end

  def bfs_for(element)
    root = self
    queue = [root]
    visited = []

    until queue.empty?
      current = queue.shift
      adjacency_list = current.children

      adjacency_list.each do |node|
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
end

module Coordinates
  attr_accessor :xy
  attr_accessor :x, :y

  def xy
    @xy ||= [0,0]
  end

  def x
    xy.first
  end

  def y
    xy.last
  end


  def with_coordinates
    i = 0
    inorder do |n|
      n.xy = [i,i]
      i += 1
    end
    self
  end
end

class Node
  include Breadth
  include Coordinates

  attr_accessor :left, :right
  attr_accessor :value

  def initialize(value: nil, left: nil, right: nil)
    @value = value
    @left = left
    @right = right
  end

  def preorder(current = self, &block)
    yield current if block
    preorder(current.left, &block) unless current.left.nil?
    preorder(current.right, &block) unless current.right.nil?
  end

  def inorder(current = self, &block)
    inorder(current.left, &block) unless current.left.nil?
    yield current if block
    inorder(current.right, &block) unless current.right.nil?
  end

  def postorder(current = self, &block)
    postorder(current.left, &block) unless current.left.nil?
    postorder(current.right, &block) unless current.right.nil?
    yield current if block
  end

  # https://leetcode.com/problems/maximum-depth-of-binary-tree/
  def height(current = self)
    return 0 if current.nil?
    lh = height(current.left)
    rh = height(current.right)
    [lh + 1, rh + 1].max
  end

  def invert(current = self)
    return current if children.empty?
    invert(current.left) unless current.left.nil?
    invert(current.right) unless current.right.nil?
    l = current.left
    current.left = current.right
    current.right = l
    current
  end

  def children
    [left, right]
  end
end
