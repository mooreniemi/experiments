def dfs(o, f)
  if o.is_a?(Hash)
    node = o[o.keys.first]
    left = node[0] unless node.nil?
    right = node[1] unless node.nil?

    dfs(left, f)
    f.call(o)
    dfs(right, f)
  end
end
