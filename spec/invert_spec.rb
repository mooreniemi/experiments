require 'spec_helper'

class Node
  attr_accessor :id
  attr_accessor :left, :right

  def initialize(id = nil)
    @id = id || ("%.6f" % Time.now.to_f)[-4..-1]
  end

  def children
    [right, left]
  end

  def childless?
    children.all?(&:nil?)
  end

  def swap_children
    self.left, self.right = self.right, self.left
    self
  end

  def to_s
    return id if childless?
    [id] + [children.map(&:to_s)]
  end
end

def invert(root)
  return root if root.nil? || root.childless?
  root.swap_children
  root.children.each(&method(:invert))
end

def invert2(root)
  return root if root.nil? || root.childless?
  root.children.each(&method(:invert2))
  root.swap_children
end

describe 'inversion' do
  describe 'supporting stuff' do
    it 'needs a tree' do
      n1 = Node.new
      l = Node.new
      r = Node.new
      n1.left = l
      n1.right = r

      expect(n1.children).to include(l,r)
    end

    it 'relies on swap_children' do
      n1 = Node.new
      l = Node.new
      r = Node.new
      n1.left = l
      n1.right = r

      n1.swap_children

      expect(n1.right).to eq(l)
      expect(n1.left).to eq(r)
    end

    it 'returns root of singleton tree' do
      root = Node.new
      expect(invert(root)).to eq(root)
    end
  end

  describe '#invert' do
    it 'inverts tree, but as a side-effect' do
      n1 = Node.new

      l = Node.new
      l2 = Node.new
      l.left = l2

      r = Node.new
      r2 = Node.new
      r.right = r2

      n1.left = l
      n1.right = r

      p n1.to_s
      invert(n1)
      p n1.to_s

      expect(n1.right).to eq(l)
      expect(n1.right.right).to eq(l2)
      expect(n1.left).to eq(r)
      expect(n1.left.left).to eq(r2)
    end
  end

  describe '#invert2' do
    it 'returns inverted tree' do
      n1 = Node.new

      l = Node.new
      l2 = Node.new
      l.left = l2

      r = Node.new
      r2 = Node.new
      r.right = r2

      n1.left = l
      n1.right = r

      p n1.to_s
      result = invert2(n1)
      p result.to_s

      expect(n1.right).to eq(l)
      expect(n1.right.right).to eq(l2)
      expect(n1.left).to eq(r)
      expect(n1.left.left).to eq(r2)
    end
  end
end
