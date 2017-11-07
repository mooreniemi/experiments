# wrong: https://www.sitepoint.com/heap-data-structure-ruby/
# wrong: https://gist.github.com/aspyct/3428688
# correct: http://www.brianstorti.com/implementing-a-priority-queue-in-ruby/
# canonical: https://en.wikipedia.org/wiki/Binary_heap
class BinaryMaxHeap
  attr_accessor :elements

  def initialize(array = [])
    @elements = []
    array.each {|e| self << e }
  end

  def <<(element)
    elements << element
    bubble_up(elements.size - 1)
    self
  end

  def pop
    swap(0, elements.size - 1)
    elements.pop.tap { bubble_down(0) }
  end

  private
  def bubble_up(i)
    parent_index = (i / 2).floor

    return if i <= 0
    return if elements[parent_index] >= elements[i]

    swap(i, parent_index)

    bubble_up(parent_index)
  end

  def bubble_down(i)
    child_index = (i * 2)

    return if child_index > elements.size - 1

    not_the_last_element = child_index < elements.size - 1

    left_element = elements[child_index + 1]
    right_element = elements[child_index + 2]

    child_index += 1 if not_the_last_element && right_element > left_element

    return if elements[i] > elements[child_index]

    swap(i, child_index)
  end

  def swap(source, target)
    elements[source], elements[target] = elements[target], elements[source]
  end
end

(array = [10, 4, 8, 2, 1, 7]).permutation.each do |a|
  fail unless BinaryMaxHeap.new(a).pop == 10
end

puts "Tested all permutations of #{array} successfully."
