# 1 2 3 4 5 6
# 1 1 2 3 5 8

def fib(n)
  fail "negatives unimplemented" if n < 0
  return n if n >= 0 && n < 2
  fib(n - 1) + fib(n - 2)
end

                   #+------------------+
                   #|                  |
              #+--> |  fib(3)          |
              #+    |                  |
      #1 + 1 = 2    +---+-------------++
                       #|             |
            #+----------+-+         +-+----------+
            #|            |         |            |
            #| fib(2)     |         | fib(1)     |
            #| # 3 - 1 = 2|         | # 3 - 2 = 1|
            #+-+---+---+--+         +------------+
#1 + 0 = 1     |       |                  |
    #+---------+--+ +--+---------+        |
    #|            | |            |        v
    #| fib(1)     | | fib(0)     |        1
    #| # 2 - 1 = 1| | # 2 - 2 = 0|
    #+------------+ +------------+
          #|              |
          #|              |
          #v              v
          #1              0

class Fibonacci
  def self.of(n)
    fail "cant use negatives" if n < 0
    return n if n >= 0 && n < 2
    first, second = 0, 1
    next_val = nil

    (2..n).each do |i|
      next_val = first + second
      first, second = second, next_val
    end

    next_val
  end
end
