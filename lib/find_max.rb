class Array
  def find_max
    pivot = (self.length / 2).floor
    list = self
    max = nil
    while max.nil?
			# fetching in case we dont have any more elements higher or lower
      if list[pivot] > list.fetch(pivot - 1,0) && list[pivot] > list.fetch(pivot + 1,0)
        max = list[pivot]
      else
        # if increasing still
        if list[pivot] > list[pivot - 1]
          list = list[pivot..-1]
          pivot = (list.length / 2).floor
        else
          list = list[0..pivot]
          pivot = (list.length / 2).floor
        end
      end
    end
    max
  end
end
