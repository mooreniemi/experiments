# http://www.markhneedham.com/blog/2012/12/23/kruskals-algorithm-using-union-find-in-ruby/
class UnionFind
  def initialize(node_count)
    @leaders = (1..node_count).each_with_object([]) {|i, leads| leads[i] = i }
  end

  def connected?(id1, id2)
    @leaders[id1] == @leaders[id2]
  end

  def union(id1, id2)
    l1, l2 = @leaders[id1], @leaders[id2]
    @leaders.each_with_index {|e, i| @leaders[i] = (e == l1) ? l2 : e }
  end
end

edges = File.read("./spec/support/edges.txt").
  split("\n")[1..-1].
  map {|line| line.split(" ").map(&:to_i) }

@mst = []
@set = UnionFind.new(edges.count)

edges.sort_by(&:last).each do |edge|
  unless @set.connected?(edge[0], edge[1])
    @mst << edge
    @set.union(edge[0], edge[1])
  end
end

p "mst: #{@mst}"
p "cost: #{@mst.reduce(0) {|acc, x| acc + x[2] } }"
