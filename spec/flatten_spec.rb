require 'spec_helper'

def flatten(array)
  flat = []
  rec_flat = proc {|a,f|
    a.each do |e|
      if e.is_a? Array
        rec_flat.call(e,f)
      else
        f << e
      end
    end
  }
  rec_flat.call(array,flat)
  flat
end

describe 'flatten(array)' do
  it 'returns an already flat array' do
    expect(flatten([1])).to eq([1])
  end
  it 'flattens a nested array' do
    expect(flatten([1,[2]])).to eq([1,2])
  end
  it 'is the same as #flatten' do
    a = [1,[2,[3]]]
    expect(flatten(a)).to eq(a.flatten)
  end
end

class Array
  def flat_stack(keep_nil = true)
    flat = []
    stack = [] << self

    until stack.empty?
      e = stack.pop

      e.each do |a|
        if a.is_a? Array
          stack << a
        else
          a = yield a if block_given?
          if keep_nil
            flat << a
          else
            flat << a unless a.nil?
          end
        end
      end
    end

    flat
  end
end

describe 'Array#flat_stack' do
  it 'returns an already flat array' do
    expect([1].flat_stack).to eq([1])
  end
  it 'flattens a nested array' do
    expect([1,[2]].flat_stack).to eq([1,2])
  end
  it 'is the same as #flatten' do
    a = [1,[2,[3]]]
    b = [1,[2,[3,4,[5]]]]
    expect(a.flat_stack).to eq(a.flatten)
    expect(b.flat_stack).to eq(b.flatten)
  end
end
