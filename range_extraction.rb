require 'minitest/autorun'
require 'pry'

def solution(list)
  first_element = list.first
  return first_element.to_s if list.size <= 1

  ranges = []

  list.each_cons(2) do |e,i| 
    previous_element = ranges.last
    actual_next = i
    expected_next = e.succ

    # is a valid two range
    if (e..actual_next) == (e..expected_next)
      # see if its range.begin is the same as the first element's range.end?
      if ranges.empty?
        ranges << (e..actual_next)
      else
        ranges << merge_ranges(ranges.pop, (e..expected_next))
      end
    else # it is just an element
      ranges << e
    end
  end
  ranges.map! {|e| format(e.to_s) if e.is_a? Range}
  ranges.join(",")
end

def merge_ranges(a,b)
  [a.begin, b.begin].min..[a.end, b.end].max
end

def format(string)
  string.gsub("..","-").delete('[]')
end

class Test < Minitest::Test
  def test_helper
    assert_equal (1..6), merge_ranges((1..3),(3..6))
  end

  def test_none
    assert_equal "", solution([])
  end

  def test_one
    assert_equal "1", solution([1])
  end

  def test_two
    assert_equal "1,2", solution([1,2])
  end

  def test_three
    assert_equal "1-3", solution([1,2,3])
  end

  def test_higher
    assert_equal "15-17", solution([15,16,17])
    assert_equal "12,13,15-17", solution([12,13,15,16,17])
    assert_equal "12,13,15-17,19,24", solution([12,13,15,16,17,19,24])
  end

  def test_canonical
    assert_equal "-6,-3-1,3-5,7-11,14,15,17-20", solution([-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20])
  end
end
