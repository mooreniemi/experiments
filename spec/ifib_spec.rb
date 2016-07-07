require 'spec_helper'

# https://www.mathsisfun.com/numbers/fibonacci-sequence.html
class Fixnum
  def fibonacci_r
    return self if self <= 1
    (self - 1).fibonacci_r + (self - 2).fibonacci_r
  end

  def fibonacci_s
    sum = 0
    stack = [self]
    while !stack.empty?
      # not really a case, haha, for a case statement
      # but wanted to play with using lambdas in one
      # http://blog.honeybadger.io/rubys-case-statement-advanced-techniques/
      case e = stack.pop
      when -> (n) { n <= 0 }
      when -> (n) { n == 1 }
        sum += e
        puts "sum: #{sum}"
      else
        stack.push(e - 1, e - 2)
        puts "stack: #{stack}"
      end
    end
    sum
  end
end

describe Fixnum do
  let(:series) { [0,1,1,2,3,5,8,13,21] }
  describe "#fibonacci_r" do
    it 'recursively give series number' do
      series.each_with_index do |fib_num, i|
        expect(i.fibonacci_r).to eq(fib_num)
      end
    end
  end
  describe "#fibonacci_s" do
    it 'uses stack to give series number' do
      series.each_with_index do |fib_num, i|
        expect(i.fibonacci_s).to eq(fib_num)
      end
    end
  end
end
