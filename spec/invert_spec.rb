require 'spec_helper'

class Node
  attr_accessor :left, :right
  alias id object_id

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
    "#{id} #{children.map(&:id)}"
  end
end

def invert(root)
  return root if root.nil? || root.childless?
  root.swap_children
  root.children.each(&method(:invert))
end

describe 'inversion' do
  it 'needs a tree' do
    n1 = Node.new
    l = Node.new
    r = Node.new
    n1.left = l
    n1.right = r

    expect(n1.children).to include(l,r)
    expect(n1.id).to eq(n1.object_id)
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

  it 'inverts tree' do
    n1 = Node.new

    l = Node.new
    l2 = Node.new
    l.left = l2

    r = Node.new
    r2 = Node.new
    r.right = r2

    n1.left = l
    n1.right = r

    invert(n1)

    expect(n1.right).to eq(l)
    expect(n1.right.right).to eq(l2)
    expect(n1.left).to eq(r)
    expect(n1.left.left).to eq(r2)
  end
end
