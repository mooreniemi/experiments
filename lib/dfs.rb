class Node
  attr_accessor :children,
    :id

  def initialize(id, children = [])
    @id = id
    @children  = children
  end
end

def dfs(root)
  puts "#{root.id}"
  [root] + root.children.flat_map(&method(:dfs))
end

leaf = Node.new("A")
parent = Node.new("B", [leaf])
grandparent = Node.new("C", [parent])

dfs(grandparent)
