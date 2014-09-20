require 'minitest/autorun'

def solution(list)
  unless list.size > 3
    list.join(",")
  else
    sublists = []
    list.each_with_index do |e, i|
      # is current element and last a valid range? 
      possible_range = (e..e+2)
      actual_range = (list[i]..list[i+2]) unless list[i+2].nil?
      puts "possible_range #{possible_range} and actual_range #{actual_range}"
      if possible_range == actual_range
        sublists << possible_range
        list = list - actual_range.to_a
      end
    end
    formatted_ranges = sublists.inject([]) {|a,l| a << rng_to_str(l.to_s)}
    return ((list + formatted_ranges).map(&:to_s)).sort.join(",")
  end
end

def rng_to_str(string)
  string.gsub("..","-").delete('[]')
end

class Test < Minitest::Test

  def test_steps
    assert_equal(solution([1]), "1", "first")
    assert_equal(solution([15,16,17]), "15-17", "second")
    assert_equal(solution([12,13,15,16,17]), "12,13,15-17", "second")
    assert_equal(solution([12,13,15,16,17,19,24]), "12,13,15-17,19,24", "third")
  end

  def test_canonical
    assert_equal(solution([-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20]), "-6,-3-1,3-5,7-11,14,15,17-20", "canonical")
  end
end
