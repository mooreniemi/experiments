class Array
  def majority_element
    majority = (self.size/2).floor
    counts = Hash.new(0)

    self.sort.each do |element|
      if counts[element]
        counts[element] += 1
      end
    end

    counts.each_pair do |element, count|
      if count >= majority
        return element
      else
        next
      end
    end

    return nil
  end
end
