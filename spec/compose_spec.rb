require 'spec_helper'

module Combinators
  refine Proc do
    def compose
      proc do |i,x|
        self.(i.(x))
      end.curry
    end

    def * other
      self.compose.(other)
    end

    def thrush
      proc do |i,x|
        i.(self.(x))
      end.curry
    end

    def % other
      self.thrush.(other)
    end

    def blackbird
      proc {|g|
        # \f g x y -> f(g x y)
        self.compose * g
      }
    end

    def psi
      proc {|g,x,y|
        # \f g x y -> f(g x) (g y)
        self.(g.(x), g.(y))
      }.curry
    end
    alias :on :psi

    def cardinal
      proc {|x,y|
        self.call(y, x)
      }.curry
    end
  end

end
using Combinators

def aggregater
  proc {|f,l|
    l.map(&f).
      reduce(0, :+)
  }.curry
end

describe '#compose' do
  let(:add_one) do
    proc {|a| a + 1 }
  end
  let(:double) do
    proc {|a| a * 2 }
  end
  let(:triple) do
    proc {|a| a * 3 }
  end
  it 'composes two procs' do
    composed = double.compose.(add_one)
    expect(composed.(2)).to eq(6)
  end
  it '* chains composition' do
    composition = triple * double * add_one
    expect(composition.(2)).to eq(18)
  end
end

describe '#blackbird' do
  let(:list) { [[1],[1,2],[1,2,3]] }
  let(:sum) do
    proc {|a| a.reduce(0, :+) }
  end
  let(:map) do
    proc {|f,a|
      a.map &f
    }.curry
  end
  it 'composition of compose' do
    aggregate = sum.blackbird.(map)
    expect(aggregate.(:length).(list)).to eq(aggregater.(:length).(list))
    expect(aggregate.(:length).(list)).to eq(6)
  end
end

describe '#psi (on)' do
  let(:comp) do
    proc {|a, b|
      a == b
    }
  end
  let(:map_length) do
    proc {|a|
      a.map(&:length)
    }
  end
  it 'can be used to compare two items by intermediation' do
    a = [[1], [2,3], [4,5,6]]
    b = [[9], [8,7], [6,5,4]]
    list_size = comp.psi.(map_length)
    expect(list_size.(a).(b)).to eq(true)
  end
end

describe '#cardinal (flip)' do
  let(:subtraction) do
    proc {|a, b| a - b }
  end
  it 'flips argument order' do
    flipper = subtraction.cardinal
    expect(flipper.(1).(2)).to eq(1)
  end
end

describe '#curry' do
  let(:add) do
    proc {|a,b| a + b }
  end
  it 'returns a partially applied proc' do
    curried = add.curry
    curried_with_one = curried.(1)
    curried_with_two = curried.(2)
    expect(curried.(1).(2)).to eq(3)
    expect(curried_with_one.(1)).to eq(2)
    expect(curried_with_two.(1)).to eq(3)
  end
end
