require 'rantly'
require 'rantly/rspec_extensions'

class Array
  def custom_reverse
    #first, *rest = *many
    case self.size
    when 0 then []
    when 1 then [self.shift]
    else custom_reverse(self).push(self.shift)
    end
  end
end

RSpec.describe "general exercise in using a list reversal test via properties" do
  context "regular single case" do
    it "reverses two element array" do
      expect([1,2].reverse).to eq([2,1])
    end
    it "reverses unsorted multi-element array" do
      expect([1,2,3,5,2].reverse).to eq([2,5,3,2,1])
    end
  end

  context "using Rantly" do
    # set up of Rantly generator of random size arrays
    let (:big_size_arrays) do
      valid_size_of_array = -> { Rantly { range 0, 50 } }
      ->(r) { array(valid_size_of_array.call) { integer }}
    end

    it "the reversed reversal is the same as the original array" do
      property_of(&big_size_arrays).check(50) { |array|
        expect(array.reverse.reverse).to eq(array)
      }
    end

    it "the reversed reversal is the same as the original array" do
      property_of(&big_size_arrays).check(50) { |array|
        expect(array.custom_reverse.custom_reverse).to eq(array)
      }
    end
  end
end
