module RadixSort
  refine Array do
    def radix_sort
      buckets = {
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

      self.each do |element|
        buckets[(element % 10)].push(element)
      end

      buckets.delete_if { |k, v| v.empty? }.values.flatten
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
end
