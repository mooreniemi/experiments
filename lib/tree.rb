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
	attr_accessor :as_rows

	def as_rows
		@as_rows ||= []
	end

	def distance
		@distance ||= Float::INFINITY
	end

	def parent
		@parent ||= nil
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
end

module Coordinates
	attr_accessor :x
	attr_accessor :y
	attr_accessor :xy

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
		inorder {|n, i = 0| i += 1; n.x = i; n.y = i}
	end
end

class Node
	include Breadth
	include Coordinates

	attr_accessor :left
	attr_accessor :right
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
