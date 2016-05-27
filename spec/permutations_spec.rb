require 'spec_helper'
require 'permutations'

describe "#permutations" do
  it 'gives back [a] for a' do
    expect("a".permutations).to eq(["a"])
  end
  it 'gives back [aa, aa] for a' do
    expect("aa".permutations).to eq(["aa", "aa"])
  end
  it 'gives back [ABC,ACB,BAC,BCA,CBA,CAB] for ABC' do
    expect("ABC".permutations).to eq(["ABC","ACB","BAC","BCA","CBA","CAB"])
  end
  it 'does the same as fb_permutations' do
    expect("ABC".permutations).to eq("ABC".fb_permutations)
  end
end
