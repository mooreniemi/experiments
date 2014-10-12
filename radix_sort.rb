require 'pry'

module RadixSort
  refine Fixnum do
    def digits
      1.to_s.ljust(self,"0").to_i
    end
  end

  refine Array do
    def radix_sort
      radices = {
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

      number_of_digits = Range.new(2,(self.max.to_s.length + 1))

      number_of_digits.to_a.each do |digit|
        reduction_factor = ("%g" % digit).to_i
        self.each do |element|
          radices[(element % digit.digits)/reduction_factor].push(element)
        end
      end

      radices.delete_if { |k, v| v.empty? }.values.flatten
    end
  end

end

RSpec.describe "Radix Sort" do
  using RadixSort

  it "sorts first digit of number by bucket" do
    expect([1,9,3,4].radix_sort).to eq([1,3,4,9])
  end

  xit "sorts second digit of number by bucket" do
    expect([12,90,32,44].radix_sort).to eq([12,32,44,90])
  end
end
