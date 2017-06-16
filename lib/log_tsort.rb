require 'tsort'
class DependencyHash < Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

require 'set'
EMPTY_SET = Set.new([nil])

class Task
  attr_accessor :id, :parent, :ancestors
  def initialize(id, parent)
    @id = id
    @parent = parent
    @ancestors = Set.new([parent])
  end
end

logfile = File.read('./spec/support/logfile.txt')
tasks = logfile.split("\n").map { |e| e.split(",").map(&:to_i) }.
        each_with_object({}) { |a,h| h[a[0]] = Task.new(a[0], a[1]) }

def path_from(node, nodes)
  return [node] if node.nil? || node.parent.nil?
  [node] + path_from(nodes[node.parent], nodes)
end

tasks.map do |_, v|
  v.ancestors.merge(path_from(v, tasks).map(&:id) - [v.id])
end

dependency_hash = tasks.each_with_object(DependencyHash.new) do |(k,v), hash|
  hash[k] = v.ancestors.to_a
end
dependency_hash[nil] = []
p dependency_hash

@result = dependency_hash.tsort
@strongly_connected = dependency_hash.strongly_connected_components

#p @strongly_connected
p @result
