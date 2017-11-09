require 'binary_search_tree'
require 'logger'
$logger = Logger.new(STDOUT)

LineSegment = Struct.new(:left, :right, :color, :height) do
  def to_s
    "#{height}: L#{left} -(#{color})> R#{right}"
  end
end

class Endpoint
  include Comparable
  attr_accessor :is_left, :line

  def initialize(is_left, line)
    @is_left = is_left
    @line = line
  end

  def <=>(other_endpoint)
    value <=> other_endpoint.value
  end

  def value
    is_left ? line.left : line.right
  end
end

def calculate_view_from_above(line_segments)
  endpoints = line_segments.each_with_object([]) do |ls, a|
    a << Endpoint.new(true, ls) << Endpoint.new(false, ls)
  end.sort

  active_line_segments = BinarySearchTreeHash.new $logger
  prev_xaxis = endpoints.first.value
  prev = nil

  has_elements = ->(bst) { bst.size > 0 }
  collected_segments = endpoints.each_with_object([]) do |endpoint, result|
    if has_elements.(active_line_segments) && prev_xaxis != endpoint.value
      active_segment = active_line_segments.max.last
      if prev.nil?
        prev = LineSegment.new(
          prev_xaxis,
          endpoint.value,
          active_segment.color,
          active_segment.height
        )
      else
        if (prev.height == active_segment.height &&
            prev.color == active_segment.color &&
            prev_xaxis == prev.right)
          prev = LineSegment.new(
            prev.left,
            endpoint.value,
            prev.color,
            prev.height
          )
        else
          result << prev
          prev = LineSegment.new(
            prev_xaxis,
            endpoint.value,
            active_segment.color,
            active_segment.height
          )
        end
      end
    end

    prev_xaxis = endpoint.value

    if endpoint.is_left
      active_line_segments[endpoint.line.height] = endpoint.line
    else
      active_line_segments.delete(endpoint.line.height)
    end
  end # endpoints.each_with_object

  prev.nil? ? collected_segments : collected_segments + [prev]
end

golden_result = [LineSegment.new(1,2,0,1), LineSegment.new(3,4,0,1)]
result = calculate_view_from_above([LineSegment.new(1,2,0,1), LineSegment.new(3,4,0,1)])
puts "Simple test: Golden? #{golden_result == result}"

golden_result = [LineSegment.new(0, 1, 0, 0), LineSegment.new(1, 3, 1, 2),
                 LineSegment.new(3, 4, 2, 1), LineSegment.new(4, 5, 3, 3),
                 LineSegment.new(5, 6, 2, 1), LineSegment.new(6, 10, 0, 2),
                 LineSegment.new(10, 11, 4, 0), LineSegment.new(11, 13, 3, 2),
                 LineSegment.new(13, 14, 4, 1), LineSegment.new(14, 15, 2, 2),
                 LineSegment.new(15, 16, 4, 0), LineSegment.new(16, 17, 3, 2),
                 LineSegment.new(17, 18, 4, 0)]

test_set = [LineSegment.new(0, 4, 0, 0), LineSegment.new(1, 3, 1, 2),
            LineSegment.new(2, 7, 2, 1), LineSegment.new(4, 5, 3, 3),
            LineSegment.new(5, 7, 3, 0), LineSegment.new(6, 10, 0, 2),
            LineSegment.new(8, 9, 0, 1), LineSegment.new(9, 18, 4, 0),
            LineSegment.new(11, 13, 3, 2), LineSegment.new(12, 15, 4, 1),
            LineSegment.new(14, 15, 2, 2), LineSegment.new(16, 17, 3, 2)]

result = calculate_view_from_above(test_set)
puts "Full test: Golden? #{golden_result == result}"
