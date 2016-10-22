def last_element_partition
  proc do |array, left_bound, right_bound|
    array[left_bound], array[right_bound] = array[right_bound], array[left_bound]
    partition(array, left_bound, right_bound)
  end
end

def median_element_partition
  proc do |array, left_bound, right_bound|
    median_choices = [
      [left_bound, array[left_bound]],
      [(middle = ((left_bound..right_bound).to_a.length / 2) - 1), array[middle]],
      [right_bound,array[right_bound]]
    ]
    median = (median_choices - median_choices.minmax { |a,b| a.last <=> b.last }).flatten
    unless median.empty? # consider too few elements for median
      # using the index of the median, not the median value itself
      array[left_bound], array[median.first] = array[median.first], array[left_bound]
    end
    partition(array, left_bound, right_bound)
  end
end

def random_partition
  proc do |array, left_bound, right_bound|
    pivot_index = rand(left_bound..right_bound)
    array[pivot_index], array[right_bound] = array[right_bound], array[pivot_index]
    partition(array, left_bound, right_bound)
  end
end

# first_element_partition, implicitly
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

def quicksort(array, l=0, n=array.length-1, &partition_method)
  return array if n-l <= 0
  if block_given?
    _, pivot_index, _ = partition_method.call(array, l, n)
  else
    _, pivot_index, _ = partition(array, l, n)
  end
  quicksort(array, l, pivot_index-1, &partition_method)
  $comparisons += (l..pivot_index-1).to_a.length
  quicksort(array, pivot_index+1, n, &partition_method)
  $comparisons += (pivot_index+1..n).to_a.length
  array
end
