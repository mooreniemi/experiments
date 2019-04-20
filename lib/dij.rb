def dij(g, target)
  unvisited = g.keys
  visited = []
  distances = unvisited.each_with_object(Hash.new(:not_found)) do |k, h|
    h[k] = Float::INFINITY
  end
  distances[unvisited.first] = 0
  paths = Hash.new([])

  until unvisited.empty?
    order = distances.sort_by { |_, v| v }.map(&:first)
    unvisited = order - visited

    current = unvisited.shift
    visited << current
    break if current == target

    g[current].entries.each do |to, distance|
      alt = distances[current] + distance
      if alt < distances[to]
        distances[to] = alt
        paths[to] += [paths[current], current].flatten
      end
    end
  end

  return [distances[target], paths[target]]
end
