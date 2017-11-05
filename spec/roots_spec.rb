require 'spec_helper'

def root(x, n)
  return 0 if x == 0

  lower_bound = 0.0
  upper_bound = x
  approx_root = (lower_bound + upper_bound) / 2.0

  while (approx_root - lower_bound >= 0.001)
    if (approx_root ** n) > x
      upper_bound = approx_root
    else
      lower_bound = approx_root
    end
    approx_root = (lower_bound + upper_bound) / 2.0
  end

  (approx_root*1000).round / 1000.0
end

describe 'find n root of x within precision 0.001' do
  it 'handles 0' do
    expect(root(0, 2)).to eq(0)
  end
  it 'should return correct answer' do
    expect(root(7, 3)).to eq(1.913)
    expect(root(9, 2)).to eq(2.999)
  end
end
