# http://www.ardendertat.com/2011/10/28/programming-interview-questions-11-all-permutations-of-string/
# http://www.geeksforgeeks.org/write-a-c-program-to-print-all-permutations-of-a-given-string/
# https://gist.github.com/corajr/769142f083b9c63496e1199732ad8371
class String
  def r_permutations
    self.chars.to_a.permutation.map(&:join)
  end

  def permutations(e = '')
    if self.length == 0
      p e
    else
      self.each_char do |fixed_char|
        substring = self.chars.reject {|c| c == fixed_char }.join
        substring.permutations(e + fixed_char)
      end
    end
  end

  def fb_permutations(char_index = 0)
    puts "char_index is #{char_index}"
    if char_index == self.size - 1
      puts self
    else
      puts "self is #{self}"
      # for each char
      self.size.times do |i|
        # swap
        puts "#{self[char_index]}, #{self[i]} = #{self[i]}, #{self[char_index]}"
        self[char_index], self[i] = self[i], self[char_index]
        # inorder traversal
        fb_permutations(char_index + 1)
        # swap back for next iteration
        self[char_index], self[i] = self[i], self[char_index]
      end
    end
  end
end
