require 'pry'

module RadixSort
  refine Fixnum do
    def digits
      1.to_s.ljust(self,"0").to_i
    end
  end

  refine Array do
    def radix_sort
      list_copy = self
      rounds = Range.new(2,(self.max.to_s.length + 1)).to_a

      rounds.each do |digit|
        radices = {
          -1=>[],
          -2=>[],
          -3=>[],
          -4=>[],
          -5=>[],
          -6=>[],
          -7=>[],
          -8=>[],
          -9=>[],
          0=>[],
          1=>[],
          2=>[],
          3=>[],
          4=>[],
          5=>[],
          6=>[],
          7=>[],
          8=>[],
          9=>[]
        }
        reduction_factor = (digit - 1).digits

        list_copy.each do |element|
          position = (element % digit.digits)/reduction_factor
          position = -position if element < 0
          radices[position].push(element)
        end
        list_copy = radices.delete_if { |k, v| v.empty? }.values.flatten
      end

      list_copy
    end
  end

end

RSpec.describe "Radix Sort" do
  using RadixSort

  it "sorts first digit of number by bucket" do
    expect([1,9,3,4].radix_sort).to eq([1,3,4,9])
  end

  it "sorts second digit of number by bucket" do
    expect([12,90,32,44].radix_sort).to eq([12,32,44,90])
  end

  it "sorts third digit of number by bucket" do
    expect([132,908,322,909,44,1].radix_sort).to eq([1,44,132,322,908,909])
    expect([170, 45, 75, 90, 2, 24, 802, 66].radix_sort).to eq([2, 24, 45, 66, 75, 90, 170, 802])
  end

  it "works with negative numbers" do
    expect([170, 45, 75, 90, 2, 24, -802, -66].radix_sort).to eq([-802, -66, 2, 24, 45, 75, 90, 170])
  end
end
