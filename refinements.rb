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

module TimeFormatter
  include MyFormats

  # this is the base method we want
  refine Time do
    def format_to_my_datetime(timezone)
      self.getlocal(timezone).strftime(MY_DATETIME_FORMAT)
    end
  end
end

require 'active_support/core_ext'

module TimeExtender
  using TimeFormatter

  # in Rails, time is often translated into an ActiveSupport::TimeWithZone object
  refine ActiveSupport::TimeWithZone do
    def method_missing(method, *args)
      # Time cant respond_to? refinements no matter where I try a `using` call because
      # Kernel methods for reflection are not in Ruby yet
      # http://stackoverflow.com/questions/15263261/why-does-send-fail-with-ruby-2-0-refinement
      if Time.respond_to?(method.to_sym)
        self.to_time.send(method.to_sym, args.first)
      end
      # even if I remove this indirect method access, Time still won't have TimeFormatter active
      # even if I put the `using` invocation inside the refine block!
    end
  end
end

module TimeTypeClass
  # acts as a type class or type constructor for "time-like" objects
  # bags different modules that encapsulate specific types
  include TimeFormatter
  include TimeExtender
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
      pending "Refinements are unfinished in Ruby core, so no access to Kernel#respond_to?"

      Time.zone = "Eastern Time (US & Canada)"
      zoned_time = Time.zone.local(2000,"jan",1,20,15,1)
      expect(cat.name("meowth$$$",zoned_time)).to eq("named meowth on #{weekday}")
    end
  end
end
