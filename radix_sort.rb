module RadixSort
  refine Array do
    def radix_sort
      buckets = {
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

      self.each do |element|
        buckets[(element % 10)] = element
      end

      buckets.delete_if { |k, v| v.is_a? Array }.values
    end
  end
end

RSpec.describe "Radix Sort" do
  using RadixSort

  it "sorts first digit of number by bucket" do
    expect([1,9,3,4].radix_sort).to eq([1,3,4,9])
  end
  xit "sorts second digit of number by bucket" do
    expect([12,90,32,44].radix_sort).to eq([12,90,32,44])
  end
end
