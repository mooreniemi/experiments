def random_partition(array, left_bound, right_bound)
  pivot_index = rand(left_bound..right_bound)
  array[pivot_index], array[right_bound] = array[right_bound], array[pivot_index]
  partition(array, left_bound, right_bound)
end

def partition(array, left_bound, right_bound)
  pivot = array[left_bound] # ~ array.first
  i = left_bound + 1 # ~ array.second
  i.upto(right_bound) do |j|
    if array[j] < pivot
      array[i], array[j] = array[j], array[i]
      i += 1
    end
  end
  pivot_index = i-1
  array[pivot_index], array[left_bound] = array[left_bound], array[pivot_index]
  [pivot, pivot_index, array]
end

def quicksort(array, l=0, n=array.length-1)
  return array if n-l <= 0
  _, pivot_index, _ = random_partition(array, l, n)
  quicksort(array, l, pivot_index-1)
  quicksort(array, pivot_index+1, n)
  p array if ENV['VERBOSE']
  array
end
