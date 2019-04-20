def bfs(h, f)
  q = [h]
  until q.empty?
    node = q.shift
    f.call(node)
    q += node.values.first unless node.values.first.nil?
  end
end
