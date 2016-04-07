class Fixnum
  def num_set_bits
    bit_string = self.to_s(2)
    bit_string.length - bit_string.gsub("1", "").length
  end
end
