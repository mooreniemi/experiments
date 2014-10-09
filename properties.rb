require 'rantly'

# list of int, int -> list of int, int
def custom_reverse(list)
  first, *rest = *list
  rest + [first]
end

RSpec.describe "general exercise in using a list reversal test via properties" do
  it "has a reversal method custom defined" do
    expect(custom_reverse([1,2])).to eq([2,1])
  end
end
