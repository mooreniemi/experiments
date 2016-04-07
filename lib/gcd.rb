class Fixnum
  def gcd(b)
    if b == 0
      self
    else
      b.gcd(self % b)
    end
  end
end
