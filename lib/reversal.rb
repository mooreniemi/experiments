# https://codelab.interviewbit.com/problems/array_2d/
class Array
  def reversal
    fail "needs to be multi-dimensional" unless self[0].is_a? Array

    total_length = self.size
    sub_length = self[0].size
    reversed = []

    total_length.times do |i|
      reversed << [0] * sub_length
      sub_length.times do |j|
        reversed[i][sub_length - 1 - j] = self[i][j]
      end
    end

    reversed
  end
end
