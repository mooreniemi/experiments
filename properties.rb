require 'pry'
require 'rantly'
require 'rantly/rspec_extensions'

RSpec.describe "general exercise in using a list reversal test via properties" do
  context "regular incremental test cases" do
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

# http://www.troikatech.com/blog/2014/04/02/property-based-testing-in-ruby/
# https://github.com/hayeah/rantly

RSpec.describe "using custom_reverse and property test" do
  def custom_reverse original_list
    new_list = original_list.inject([]) { |list,e| list.unshift(e) }
  end

  context "regular incremental test cases" do
    it "custom reverses unsorted multi-element array" do
      expect(custom_reverse([1,2,3,5,2])).to eq([2,5,3,2,1])
    end

    it "custom reverses a single element array" do
      expect(custom_reverse([1])).to eq([1])
    end

    it "custom reverses returns empty array" do
      expect(custom_reverse([])).to eq([])
    end
  end

  context "using Rantly" do
    let (:big_size_arrays) do
      valid_size_of_array = -> { Rantly { range 0, 50 } }
      ->(r) { array(valid_size_of_array.call) { integer }}
    end

    it "the reversed reversal is the same as the original array" do
      property_of(&big_size_arrays).check(50) { |array|
        original_array = array.dup
        reversed_array = custom_reverse(array)
        expect(custom_reverse(reversed_array)).to eq(original_array)
      }
    end
  end
end
