require 'rantly'
require 'rantly/rspec_extensions'

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
        reversed_array = array.reverse
        expect(reversed_array.reverse).to eq(array)
      }
    end
  end
end

RSpec.xdescribe "using custom_reverse and property test" do
  context "custom reversal" do
    class Array
      def custom_reverse
        #first, *rest = *many
        new_list = self.empty? ? self : [self.pop]
        until self.empty?
          new_list.push(self.pop)
        end
        new_list
      end
    end

    let (:big_size_arrays) do
      valid_size_of_array = -> { Rantly { range 0, 50 } }
      ->(r) { array(valid_size_of_array.call) { integer }}
    end

    it "custom reverses unsorted multi-element array" do
      expect([1,2,3,5,2].custom_reverse).to eq([2,5,3,2,1])
    end

    it "the reversed reversal is the same as the original array" do
      property_of(&big_size_arrays).check(50) { |array|
        reversed_array = array.custom_reverse
        expect(reversed_array.custom_reverse).to eq(array)
      }
    end
  end
end
