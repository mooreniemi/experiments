require 'spec_helper'
require 'support/csp'

describe 'what do you want for dinner?' do
  let(:csp) { CSP.new }
  let(:meals) do
    ['red sauce',
     'burritos',
     'shwarma',
     'mushroom sauce',
     'pizza',
     'chinese',
     'dogwood'].freeze
  end
  let(:weekdays) do
    %i(monday tuesday
       wednesday thursday
       friday saturday sunday)
  end
  it 'no repeated meals' do
    weekdays.each do |wd|
      csp.var wd, meals
    end
    csp.all_pairs(weekdays) { |a, b| a != b }
    expect(csp.solve).to eq(
      monday: 'red sauce',
      tuesday: 'burritos',
      wednesday: 'shwarma',
      thursday: 'mushroom sauce',
      friday: 'pizza',
      saturday: 'chinese',
      sunday: 'dogwood'
    )
  end
end
