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

