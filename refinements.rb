require 'pry'

module MyFormats
  MY_NAME_FORMAT = /[^A-Za-z0-9_]/
  MY_DATETIME_FORMAT = "%A"
end

module StringFormatter
  include MyFormats

  refine String do
    def format_to_my_name
      self.gsub(MY_NAME_FORMAT,"")
    end
  end
end

module TimeFormatter
  include MyFormats

  refine Time do
    def format_to_my_datetime(timezone)
      self.getlocal(timezone).strftime(MY_DATETIME_FORMAT)
    end
  end
end

require 'active_support/core_ext'

module TimeExtender
  using TimeFormatter
  refine ActiveSupport::TimeWithZone do
    def method_missing(method, *args)
      # Time always returns false, no matter where I try a `using` call because
      # http://stackoverflow.com/questions/15263261/why-does-send-fail-with-ruby-2-0-refinement
      if Time.respond_to?(method.to_sym)
        self.to_time.send(method.to_sym, args.first)
      end
    end
  end
end

module TimeTypeClass
  include TimeFormatter
  include TimeExtender
end

class Kitten
  using TimeTypeClass
  using StringFormatter

  def name(string, time)
    "named #{string.format_to_my_name} on " + time.format_to_my_datetime("-06:00")
  end
end

RSpec.describe "time type class refinement experiment" do
  let(:cat) { Kitten.new }
  context "for Time class" do
    it "should be able to format string and time" do
      expect(cat.name("meowth$$$",Time.now)).to eq("named meowth on Monday")
    end
  end
  context "for ActiveSupport::TimeWithZone" do
    it "should be able to format string and time" do
      Time.zone = "Eastern Time (US & Canada)"
      zoned_time = Time.zone.local(2000,"jan",1,20,15,1)
      expect(cat.name("meowth$$$",zoned_time)).to eq("named meowth on Monday")
    end
  end
end
