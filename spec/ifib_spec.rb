require 'spec_helper'

class Fixnum
  def fibonacci
    return 1 if self <= 1
    (self - 2).fibonacci + (self - 1).fibonacci
  end
end

describe Fixnum do
  it 'has a fibonnaci method' do
    expect(3.fibonacci).to eq(2)
    expect(4.fibonacci).to eq(3)
  end
end
