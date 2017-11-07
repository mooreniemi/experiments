# wrong: https://www.sitepoint.com/heap-data-structure-ruby/
# wrong: https://gist.github.com/aspyct/3428688
# canonical: https://en.wikipedia.org/wiki/Binary_heap
class BinaryMaxHeap
  attr_accessor :array_representation

  CHILD = ->(offset,i) { 2*i + offset }.curry
  PARENT = ->(i) { (i-1 / 2).floor }

  def initialize(elements = [])
    fail unless elements.is_a? Array
    @array_representation = elements
    reheap
  end

  def <<(element)
    @array_representation.unshift(element).tap { reheap }
  end

  def peek_max
    array_representation.first
  end

  def pop_max
    array_representation.shift.tap { reheap }
  end

  private
  def reheap
    array_representation.each_with_index {|_,i| heapify(i) }
    self
  end

  def heapify(i)
    p "sinking element #{array_representation[i]}"
    return if leaf_node?(i) || satisfied?(i)

    larger_child = left_child(i) > right_child(i) ? left_child_index(i) : right_child_index(i)

    array_representation[i], array_representation[larger_child] = array_representation[larger_child], array_representation[i]

    heapify(larger_child)
  end

  def satisfied?(i)
    e = array_representation[i]
    e >= left_child(i) && e >= right_child_index(i)
  end

  def leaf_node?(i)
    i >= array_representation.size/2
  end

  def left_child(i)
    array_representation[left_child_index(i)] || -Float::INFINITY
  end
  def right_child(i)
    array_representation[right_child_index(i)] || -Float::INFINITY
  end

  def left_child_index(i)
    CHILD.(1).(i)
  end
  def right_child_index(i)
    CHILD.(2).(i)
  end
end

a = [10, 4, 8, 2, 1, 7].shuffle
p "heapifying #{a}, exported as @heap"

@heap = BinaryMaxHeap.new(a)
p "#{@heap.peek_max} should be #{a.max}"
