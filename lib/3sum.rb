class Array
  def three_sum
    sorted = self.sort
    combos = []

    (self.size - 3).times do |i|
      a = sorted[i]
      start = i + 1
      ending = self.size - 1

      while start < ending do
        b = sorted[start]
        c = sorted[ending]

        if a + b + c == 0
          puts "#{a} + #{b} + #{c} == 0"
          combos << [a, b, c]
          ending = ending - 1
        elsif a + b + c > 0
          ending = ending - 1
        else
          start = start + 1
        end
      end
    end

    combos
  end
end
