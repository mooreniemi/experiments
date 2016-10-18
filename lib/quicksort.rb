def partition(array, left_bound, right_bound)
  pivot = array[left_bound] # ~ array.first
  i = left_bound + 1 # ~ array.second
  i.upto(right_bound) do |j|
    if array[j] < pivot
      array[i], array[j] = array[j], array[i]
      i += 1
    end
  end
  array[i-1], array[left_bound] = array[left_bound], array[i-1]
  pivot_index = i-1
  [pivot, pivot_index, array]
end

def quicksort(array, l=0, n=array.length-1)
  return array if n-l <= 0
  if l < n
    _, pivot_index, _ = partition(array, l, n)
    quicksort(array, l, pivot_index-1)
    quicksort(array, pivot_index+1, n)
    p array if ENV['VERBOSE']
    array
  end
end

# require 'ruby-prof'
# profiled_array = (0..33).to_a.shuffle

# RubyProf.start
# quicksort(profiled_array)
# result = RubyProf.stop

# printer = RubyProf::FlatPrinter.new(result)
# printer.print(STDOUT)
