class Array
  def fb_rotate(places)
    ret = []
    bound = self.size
    bound.times do |i|
      puts (i + places) % bound
      ret << self[(i + places) % bound]
    end
    ret
  end
end
