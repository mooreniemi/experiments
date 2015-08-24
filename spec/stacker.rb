require 'pry'
def stacker(array)
  array.inject([]) do |memo, item, pair = [item,0]|
    hash_id = (item.hash/100000000000).abs
    count = (memo[hash_id].nil? ? 0 : memo[hash_id][1])
    pair = [item, count + 1]

    memo[hash_id].nil? ? nil : memo.delete_at(hash_id)
    memo.insert(hash_id,pair)
  end.compact
end

RSpec.describe "count without hash" do
  def random_string_array_of(number_words)
    proc = proc {[*('A'..'Z')].sample(8).join}
    Array.new(number_words,&proc)
  end
  let(:small_array) { ["foo", "foo", "doo"]}

  it 'should return pair of value and count' do
    expect(stacker(["foo"])).to eq([["foo",1]])
  end
  it 'should return count of two values' do
    expect(stacker(["foo", "foo"])).to eq([["foo",2]])
  end
  it 'should not overcount' do
    expect(stacker(small_array)[1]).to eq(["foo",2])
  end
  it 'should give us accurate counts' do
    expect(stacker(small_array).sort).to eq([["foo", 2],["doo", 1]].sort)
  end
  xit 'should work for vvverrryyy biggg arrayyys' do
    expect(stacker(random_string_array_of(5000))).to be_a(Array)
  end
  it 'should match other behavior' do
    expect(small_array.inject(Hash.new(0)) {|h, item| h.merge!({item => h[item] + 1})}).to eq({"foo"=>2, "doo"=>1})
  end
end
