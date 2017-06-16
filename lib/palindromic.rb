# https://leetcode.com/problems/largest-palindrome-product
# @param {Integer} n
# @return {Integer}
def largest_palindrome(nu)
  return 9 if nu == 1

  lower_bound = ("1" * nu).to_i
  j = ("9" * nu).to_i
  i = j
  max = 0
  sum = 0

  until i < sum / 2
    j = i
    until j == lower_bound || i + j < sum
      #p "i: #{i}, j: #{j}"
      if (product = (i * j)).is_palindrome?
        sum = i + j
        max = product if product > max
        p "max: #{max}"
      end
      j -= 1
    end
    i -= 1
  end

  max % 1337
end

class Numeric
  def is_palindrome?
    _num = self
    rev = 0
    while _num > 0 do
      digit = _num % 10
      rev = rev * 10 + digit
      _num = _num / 10
    end
    rev == self
  end
end
