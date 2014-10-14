require 'pry'
require 'active_support/core_ext'
module A
  refine Time do
    def weekday
      self.strftime("%A")
    end
  end

  refine ActiveSupport::TimeWithZone do
    def method_missing(method, *args)
      coerced = self.to_time
      eval("coerced.#{method}")
    end
  end

  refine String do
    def method_missing(method, *args)
      parsed = Time.parse(self)
      eval("parsed.#{method}")
    end
  end
end

class B
  using A
  def gimme_weekday(time)
    time.weekday
  end
end

RSpec.describe "time type class refinement experiment" do
  let(:instance) { B.new }
  let(:weekday) { Time.now.strftime("%A") }

  context "for Time class" do
    it "should be able to format time" do
      expect(instance.gimme_weekday(Time.now)).to eq("#{weekday}")
    end
  end

  context "for ActiveSupport::TimeWithZone" do
    it "should be able to format time" do
      Time.zone = "Eastern Time (US & Canada)"
      zoned_time = Time.zone.local(2000,"jan",20,20,15,1)
      expect(instance.gimme_weekday(zoned_time)).to eq("#{weekday}")
    end
  end

  context "crazy String parse" do
    it "should be able to format time" do
      time_string = "2000-01-20 12:22:26"
      expect(instance.gimme_weekday(time_string)).to eq("#{weekday}")
    end
  end
end
