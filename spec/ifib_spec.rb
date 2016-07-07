require 'spec_helper'

module Fibonacci
  refine Fixnum do
    class ZeroOrBelow
      def self.===(i)
        i <= 0
      end
    end

    class One
      def self.===(i)
        i == 1
      end
    end

    def fibonacci_r
      return self if self <= 1
      (self - 1).fibonacci_r + (self - 2).fibonacci_r
    end

    def fibonacci_s
      sum = 0
      stack = [self]
      while !stack.empty?
        case e = stack.pop
        when ZeroOrBelow #-> (n) { n <= 0 }
          # http://blog.honeybadger.io/rubys-case-statement-advanced-techniques/
          # commented after is the lambda version
        when One #-> (n) { n == 1 }
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
end

describe Fixnum do
  using Fibonacci
  # https://www.mathsisfun.com/numbers/fibonacci-sequence.html
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
