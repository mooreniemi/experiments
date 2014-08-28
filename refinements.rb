# Literate-ish programming file.

module MyFormats
  # for constants
  MY_NAME_FORMAT = /[^A-Za-z0-9_]/
  MY_DATETIME_FORMAT = "%A"
end

module StringFormatter
  include MyFormats

  # unlike time, string isn't really rewrapped in other objects commonly
  refine String do
    def format_to_my_name
      self.gsub(MY_NAME_FORMAT,"")
    end
  end
end

require 'active_support/core_ext'

module TimeTypeClass
  include MyFormats

  # this is the base method we want
  refine Time do
    def format_to_my_datetime(timezone)
      self.getlocal(timezone).strftime(MY_DATETIME_FORMAT)
    end
  end

  # When defining multiple refinements in the same module,
  # inside a refine block all refinements from the same module
  # are active when a refined method is called

  # in Rails, time is often translated into an ActiveSupport::TimeWithZone object
  refine ActiveSupport::TimeWithZone do
    puts Time.format_to_my_datetime("-05:00")
    def method_missing(method, *args)
      self.to_time.send(method.to_sym, args.first)
    end
  end
end

class Kitten
  # wants to operate on both types of Time
  using TimeTypeClass
  # only needs single String refinement
  using StringFormatter

  def name(string, time)
    "named #{string.format_to_my_name} on " + time.format_to_my_datetime("-06:00")
  end
end

RSpec.describe "time type class refinement experiment" do
  let(:cat) { Kitten.new }
  let(:weekday) { Time.now.strftime("%A") }

  context "for Time class" do
    it "should be able to format string and time" do
      expect(cat.name("meowth$$$",Time.now)).to eq("named meowth on #{weekday}")
    end
  end

  context "for ActiveSupport::TimeWithZone" do
    it "should be able to format string and time" do
      Time.zone = "Eastern Time (US & Canada)"
      zoned_time = Time.zone.local(2000,"jan",1,20,15,1)
      expect(cat.name("meowth$$$",zoned_time)).to eq("named meowth on #{weekday}")
    end
  end
end
