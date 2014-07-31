require 'pry'
# http://mikeburnscoder.wordpress.com/2009/05/30/powerset-in-ruby-using-the-list-monad/
# https://github.com/pzol/monadic/blob/master/lib/monadic/monad.rb
# http://www.haskell.org/ghc/docs/latest/html/libraries/base/src/Control-Monad.html#filterM

module ArrayExtensions
  refine Array do
    def coulder
      self.slice(1, self.length)
    end
  end
end

using ArrayExtensions

module Enumerable
  #     -- | This generalizes the list-based 'filter' function.
  # filterM          :: (Monad m) => (a -> m Bool) -> [a] -> m [a]
  # filterM _ []     =  return []
  # filterM p (x:xs) =  do
  #    flg <- p x
  #    ys  <- filterM p xs
  #    return (if flg then x:ys else ys)
  def filterM(&p)
    puts p.inspect
  end
end

class Monad
  def initialize(value)
    @value = unit(value)
  end
  def unwrap
    @value
  end
  # M[M[A]] is equivalent to M[A]
  def unit(e)
    if e.is_a? self.class
      e.unwrap
    else
      e
    end
  end
  def bind(&f)
    f.call(@value)
  end
  def powerset
    self.filterM {|x| Monad.new(true, false)}
  end
end

RSpec.describe "monad enumerable experiment" do
  context "Array is refined with coulder" do
    it "should return every element in an array except the first" do
      array = [1, 2, 3, 4, 5]
      expect(array.coulder).to eq([2, 3, 4, 5])
    end
  end
  context "Monad" do
    context "#unit" do
      it "should return the value of the monad" do
        monad = Monad.new([1, 2, 3, 4])
        expect(monad.unit(Monad.new([1, 2, 3, 4]))).to eq([1, 2, 3, 4])
      end
    end
    context "#bind" do
      it "should be able to access the value inside the monad" do
        monad = Monad.new([1, 2, 3, 4])
        proc = proc {|e| e.rotate}
        expect(monad.bind(&proc)).to eq([2, 3, 4, 1])
      end
      it "should be able to map within the bound proc on the collection value" do
        monad = Monad.new([1, 2, 3, 4])
        proc = proc {|c| c.map(&:to_s) }
        expect(monad.bind(&proc)).to eq(["1", "2", "3", "4"])
      end
    end
    context "#powerset" do
      it "should return a set of all possible sets" do
        pending
        monad = Monad.new([1,2,3])
        expect(monad.powerset).to eq([[1, 2, 3], [1, 2], [1, 3], [1], [2, 3], [2], [3], []])
      end
    end
  end
  context "Enumerable is refined with filterM" do
    it "should filter monadic collections" do
      pending
      monad = Monad.new([1,2,3,4,5])
      proc = proc {|e| Monad.new([e + 1])}
      expect(monad.filterM &proc).to eq([[], [6], [5], [4], [3], [2]])
    end
  end
end
