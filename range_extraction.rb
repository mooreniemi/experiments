require 'minitest/autorun'
require 'pry'

def solution(list)
  return "" if list.empty?
  
  list_of_lists = list.inject([]) do |m,e|
    m << [] if m.empty?
    m.last.last == (e-1) ? m.last << e : m << [e]
    m
  end.reject!(&:empty?)

  list_of_lists.inject([]) do |m,l| 
    if l.size > 2 
      m << (l.first.to_s + "-" + l.last.to_s) 
    elsif l.size == 2
      m << (l.first.to_s + "," + l.last.to_s) 
    else
      m << l.first.to_s
    end
  end.join(",")
end

class Test < Minitest::Test

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
