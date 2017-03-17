class Array
  def rank(k)
    b = self.dup
    until b.empty?
      e = b.shift
      c = self.count {|i| i > e }
      return e if c == k - 1
    end
  end
end

