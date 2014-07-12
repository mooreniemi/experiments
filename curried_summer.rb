RSpec.describe "currying experiment" do
  context "with single argument function" do
    summer = proc {|sum, n| sum + n}
    rap = proc {|proc| (1..5).inject 0, &proc}
    curried = rap.curry

    it "should simply return proc result as normal" do
      expect(curried[summer]).to eq(15)
    end
  end

  context "with partially applicable function" do
    summer = proc {|sum, n| sum + n}
    rap = proc {|collection, proc| collection.inject 0, &proc}
    curried = rap.curry

    it "should simply return proc with only one argument" do
      expect(curried[summer]).to be_a_kind_of(Proc)
    end

    it "should return when two arguments are passed in" do
      expect(curried[(1..5)][summer]).to eq(15)
    end

    it "should easily allow me to do function application" do
      partial = curried[(1..5)]
      expect(partial[summer]).to eq(15)
    end
  end

  context "with fully abstracted injection" do
    odds_proc = proc { |a, e| e.odd? ? a << e : a }
    rap = proc {|collection, proc, memo| collection.inject memo, &proc}
    curried = rap.curry

    it "should simply return proc with only one argument" do
      expect(curried[(1..10)]).to be_a_kind_of(Proc)
    end

    it "should simply return proc when two arguments are passed in" do
      expect(curried[(1..10)][odds_proc]).to be_a_kind_of(Proc)
    end

    it "should easily allow me to do function application" do
      partial = curried[(1..10)][odds_proc]
      odds = partial[[]]
      expect(odds).to eq([1,3,5,7,9])
    end
  end

  context "for wrapping merges functionally" do
    names = ["Jason", "Jason", "Teresa", "Judah", "Michelle", "Judah", "Judah", "Allison"]
    names_proc = proc {|collection, a, e| a.merge({e => collection.count(e)})}

    curried_names_proc = names_proc.curry[names]

    rap = proc {|collection, proc| collection.inject({}, &proc)}
    curried = rap.curry

    it "should allow a proc that does merging" do
      partial = curried[names]
      count_hash = partial[curried_names_proc]
      expect(count_hash).to eq({"Jason"=>2, "Teresa"=>1, "Judah"=>3, "Michelle"=>1, "Allison"=>1})
    end
  end

  context "for wrapper merges in OO style" do
    module Procs
      def names
        proc {|collection, a, e| a.merge({e => collection.count(e)})}
      end
      def injector
        proc {|collection, proc| collection.inject({}, &proc)}.curry
      end
    end

    class Receiver
      include Procs
      attr_accessor :collection

      def initialize(options = {})
        @collection = options[:collection]
      end

      def wrapper proc
        proc.curry[self.collection]
      end
    end
    
    receiver = Receiver.new(collection: ["Jason", "Jason", "Teresa", "Judah", "Michelle", "Judah", "Judah", "Allison"])
    
    wrapped = receiver.wrapper receiver.names

    it "a partial application of collection, that takes a proc" do
      partial = receiver.injector[receiver.collection]
      count_hash = partial[wrapped]
      expect(count_hash).to eq({"Jason"=>2, "Teresa"=>1, "Judah"=>3, "Michelle"=>1, "Allison"=>1})
    end
  end
end
