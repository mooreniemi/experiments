require 'spec_helper'

# https://www.mathsisfun.com/numbers/fibonacci-sequence.html
class Fixnum
  def fibonacci_r
    return self if self <= 1
    (self - 1).fibonacci_r + (self - 2).fibonacci_r
  end

  def fibonacci_s
    results = []
    stack = [self]
    while !stack.empty?
    end
    results
  end
end

describe Fixnum do
  describe "#fibonacci_r" do
    it 'recursively give series number' do
      expect(1.fibonacci_r).to eq(1)
      expect(2.fibonacci_r).to eq(1)
      expect(3.fibonacci_r).to eq(2)
      expect(4.fibonacci_r).to eq(3)
      expect(5.fibonacci_r).to eq(5)
      expect(6.fibonacci_r).to eq(8)
      expect(7.fibonacci_r).to eq(13)
    end
  end
  describe "#fibonacci_s" do
    it 'uses stack to give series number' do
      expect(1.fibonacci_s).to eq(1)
      expect(2.fibonacci_s).to eq(1)
      expect(3.fibonacci_s).to eq(2)
      expect(4.fibonacci_s).to eq(3)
      expect(5.fibonacci_s).to eq(5)
      expect(6.fibonacci_s).to eq(8)
      expect(7.fibonacci_s).to eq(13)
    end
  end
end
