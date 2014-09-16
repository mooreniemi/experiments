def snail(collection)
  slime = []
  r_perimeter = collection.inject([]) {|a,e| a << e.last}
  l_perimeter = collection.inject([]) {|a,e| a << e.first}
  size = collection.size

  case size
  when 1
    slime << collection
  when 2
    slime << collection[0]
    slime << collection[1].reverse
  when 3
    slime << collection[0]
    slime << r_perimeter[1..-1]
    slime << collection[2][0..1].reverse
    slime << collection[1][0..1]
  when 4
    slime << collection[0]
    slime << r_perimeter[1..-1]
    slime << collection[3].reverse[1..2]
    slime << l_perimeter[1..3].reverse
    slime << collection[1][1..2]
    slime << collection[2][1..2].reverse
  else
    puts "not yet"
  end

  slime.flatten
end

RSpec.describe "snail trail algorithm" do
  it "returns empty array" do
    expect(snail([[]])).to eq([])
  end
  it "can flatten the output" do
    expect(snail([[1,2],[3,4]])).to eq([1,2,4,3])
  end
  it "reverses at end" do
    expect(snail([[1,2,3],[4,5,6],[7,8,9]])).to eq([1,2,3,6,9,8,7,4,5])
  end
  it "handles 4" do
    expect(snail([[1,2,3,1],[4,5,6,4],[7,8,9,7],[7,8,9,7]])).to eq([1,2,3,1,4,7,7,9,8,7,7,4,5,6,9,8])
  end
end
