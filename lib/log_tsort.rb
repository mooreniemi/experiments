require 'tsort'
class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

require 'set'
EMPTY_SET = Set.new([nil])

class Task
  attr_accessor :id, :parents
  def initialize(id, parent)
    @id = id
    @parents = Set.new([parent])
  end
end

logfile = File.read('./spec/support/logfile.txt')
tasks = logfile.split("\n").map { |e| e.split(",").map(&:to_i) }.
        each_with_object({}) { |a,h| h[a.first] = Task.new(a[0], a[1]) }

def path_from(node, nodes)
  return node if node.nil? || node.parents == EMPTY_SET
  [node] + node.parents.flat_map do |pid|
    path_from(nodes[pid], nodes)
  end
end

paths = tasks.map do |_, v|
  path_from(v, tasks)
end

paths.each do |path|
  next unless path.is_a? Array
  path.reverse.each_with_index do |e, i|
    next if e.nil? || e.parents == EMPTY_SET
    e.parents.merge(path[i-1].parents)
  end
end

dependency_hash = tasks.each_with_object({}) do |(k,v), hash|
  hash[k] = v.parents.to_a
end
dependency_hash[nil] = []

@result = dependency_hash.tsort

p @result
