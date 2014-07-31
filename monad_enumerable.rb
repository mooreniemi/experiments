require 'pry'
# http://mikeburnscoder.wordpress.com/2009/05/30/powerset-in-ruby-using-the-list-monad/
# https://github.com/pzol/monadic/blob/master/lib/monadic/monad.rb
# http://www.haskell.org/ghc/docs/latest/html/libraries/base/src/Control-Monad.html#filterM

module ArrayExtensions
  refine Array do
    def coulder
      self.slice(1,self.length)
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
    return self.class.unit(ListMonad[]) if self.empty?
    p.call(self.first).bind do |flg|
      self.coulder.filterM(&p).bind do |ys|
        self.class.unit(flg ? (ListMonad[self.first] + ys) : ys)
      end
    end
  end
end

class ListMonad < Array
  def initialize(value)
    @value = unit(value)
  end
  def unwrap
    @value
  end
  def unit(e)
    if e.is_a? self.class
      e.unwrap
    else
      ListMonad[e]
    end
  end
  def bind(&f)
    self.inject(ListMonad[]) {|memo, e| memo << f.call(e) ; memo}
  end
  def powerset
    self.filterM {|x| ListMonad[true, false]}
  end
end

RSpec.describe "monad enumerable experiment" do
  context "Array is refined with coulder" do
    it "should return every element in an array except the first" do
      array = [1,2,3,4,5]
      expect(array.coulder).to eq([2,3,4,5])
    end
  end
  context "ListMonad" do
    context "#unit" do
      it "should return the value of the monad" do
        list = ListMonad.new([true, false])
        expect(list.unit([true,false])).to eq([true,false])
      end
    end
    context "#bind" do
      it "should" do
      end
    end
    context "#powerset" do
      it "should return a set of all possible sets" do
        list = ListMonad[1,2,3]
        expect(list.powerset).to eq([[1, 2, 3], [1, 2], [1, 3], [1], [2, 3], [2], [3], []])
      end
    end
  end
  context "Enumerable is refined with filterM" do
    it "should filter monadic collections" do
      list = ListMonad[1,2,3,4,5]
      proc = proc {|e| ListMonad[e + 1]}
      expect(list.filterM &proc).to eq([[], [6], [5], [4], [3], [2]])
    end
  end
end
