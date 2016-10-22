require 'spec_helper'

class Fixnum
  def cycle_length
    conj = proc {|a| a % 2 == 0 ? a / 2 : a * 3 + 1}
    length = 1 # include self
    cyc = proc do |a|
      until a == 1
        length += 1
        a = conj.(a)
      end
    end
    cyc.(self)
    length
  end
end

describe '3n+1 problem' do
  it 'calculates a cycle-length' do
    expect(22.cycle_length).to eq(16)
  end
  it 'can be used to #map and get #max' do
    endpoints = [(1..10), (100..200), (201..210), (900..1000)]
    longest_cycles = [20, 125, 89, 174]
    test_cases = endpoints.zip(longest_cycles)

    test_cases.each do |t|
      nums = t.first.to_a
      longest_cycle_length = t.last
      expect(nums.map(&:cycle_length).max).to eq(longest_cycle_length)
    end
  end
end
