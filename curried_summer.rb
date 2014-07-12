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
    curried_hash_injector = proc {|collection, proc| collection.inject({}, &proc)}.curry

    it "should allow a proc that does merging" do
      partial = curried_hash_injector[names]
      count_hash = partial[curried_names_proc]
      expect(count_hash).to eq({"Jason"=>2, "Teresa"=>1, "Judah"=>3, "Michelle"=>1, "Allison"=>1})
    end
  end

  context "trying to get a different self inside a block" do
    # Needing to have collection set twice (above example) bugs me. Why shouldn't my names_proc be able to see its original receiver?
    # So I create a Receiver class, with a collection, hoping I can get that receiver.
    class Receiver
      attr_accessor :collection

      def initialize(options = {})
        @collection = options[:collection]
      end

      def wrapper &block
        proc { instance_eval &block }
      end
    end

    receiver = Receiver.new(collection: ["Jason", "Jason", "Teresa", "Judah", "Michelle", "Judah", "Judah", "Allison"])

    # Here I am hoping I can call "self" and actually have the collection returned to me, but of course I get the Receiver instance.
    names_proc = proc {|a, e| a.merge({e => self.count(e)})}
    # Wishful thinking.
    wrapped = receiver.wrapper &names_proc

    curried = proc {|collection, proc| collection.inject({}, &proc)}.curry
    partial = curried[receiver.collection]
    
    it "mistakenly assigns a to Receiver rather than the injected Hash" do
      expect { partial[wrapped] }.to raise_error(NoMethodError)
      #=> undefined method `merge' for #<Receiver:0x000001013811a0>
    end
  end

  context "a wrapper merge bending OO to be more type-like" do
    module Procs
      # Treats Procs module as a type class, that any type with a collection attribute may implement.
      def names
        proc {|a, e| a.merge({e => self.collection.count(e)})}
      end
      def injector
        proc {|collection, proc| collection.inject({}, &proc)}.curry
      end
    end

    class Receiver
      # So "Receiver" is more like a type than a class.
      include Procs
      attr_accessor :collection

      def initialize(options = {})
        @collection = options[:collection]
      end
    end

    receiver = Receiver.new(collection: ["Jason", "Jason", "Teresa", "Judah", "Michelle", "Judah", "Judah", "Allison"])

    it "a partial application of collection, that takes a proc" do
      partial = receiver.injector[receiver.collection]
      count_hash = partial[receiver.names]
      expect(count_hash).to eq({"Jason"=>2, "Teresa"=>1, "Judah"=>3, "Michelle"=>1, "Allison"=>1})
    end
  end
end
