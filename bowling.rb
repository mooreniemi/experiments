# http://content.codersdojo.org/code-kata-catalogue/bowling-game/

def score(rolls)
  # rolls are associative in a sparse array, reduce
  rolls.flatten.reduce(:+)
end

RSpec.describe "Bowling Score Kata" do
  it "takes a representation of rolls and returns a score" do
    # 10 frames, 30 points possible per frame
    all_rolls = Array.new(10, [0,0,0])
    expect(score(all_rolls)).to eq(0)
  end

    it "takes a representation of rolls and returns a score" do
    all_rolls = Array.new(10, [1,9,5])
    expect(score(all_rolls)).to eq(150)
  end
end