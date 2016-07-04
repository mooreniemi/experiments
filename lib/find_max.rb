class Array
  def find_max
    pivot = (self.length / 2).floor
    max = nil
    while max.nil?
      if self[pivot] > self[pivot - 1] && self[pivot] > self[pivot + 1]
        max = self[pivot]
      else
        if self[pivot] > self[pivot - 1]
          pivot = (self[pivot + 1..-1][0] / 2).floor
        else
          pivot = (self[0..pivot - 1][0] / 2).floor
        end
      end
    end
    max
  end
end
