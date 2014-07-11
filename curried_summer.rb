RSpec.describe "currying experiment" do
  context "with single argument function" do
    summer = Proc.new {|sum, n| sum + n}
    rap = Proc.new {|proc| (1..5).inject 0, &proc}
    curried = rap.curry

    it "should simply return proc result as normal" do
      expect(curried[summer]).to eq(15)
    end
  end

  context "with partially applicable function" do
    summer = Proc.new {|sum, n| sum + n}
    rap = Proc.new {|collection, proc| collection.inject 0, &proc}
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
    odds_proc = Proc.new { |a, e| e.odd? ? a << e : a }
    rap = Proc.new {|collection, proc, memo| collection.inject memo, &proc}
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
end
