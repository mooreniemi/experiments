require 'spec_helper'
require 'rantly/rspec_extensions'
require 'find_max'

describe Array do
  describe '#find_max' do
    it 'returns max element in camel list' do
      expect([1,3,2].find_max).to eq(3)
      expect([1,2,3,7,6,5].find_max).to eq(7)
    end
    it 'satisfies property test' do
      property_of {
        array(49) { range(1,998) }.sort + [999] +
        array(49) { range(1, 998) }.sort { |x,y| y <=> x }
      }.check {|array|
        expect(array.find_max).to eq(999)
      }
    end
  end
end
