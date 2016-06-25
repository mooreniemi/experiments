require 'spec_helper'

# http://www.redblobgames.com/pathfinding/a-star/implementation.html
# http://www.redblobgames.com/pathfinding/grids/graphs.html

DIRECTIONS = [[1,0],[0,1],[-1,0],[0,-1]]
GRID_COORDINATES = []
24.times do |x|
  24.times do |y|
    GRID_COORDINATES << [x,y]
  end
end

def neighbors_of(node)
  DIRECTIONS.inject([]) do |neighbors, direction|
    neighbor = [node[0] + direction[0], node[1] + direction[1]]
    if GRID_COORDINATES.include?(neighbor)
      neighbors << neighbor
    end
    neighbors
  end
end

# buildings = [[15,16],[5,10],[23,2],[23,18],[17,20],[2,23],[16,10]]

class SimpleGraph
  attr_accessor :edges
  def initialize(edges = {})
    @edges = edges
  end
  def neighbors_of(node_id)
    edges[node_id]
  end
end
