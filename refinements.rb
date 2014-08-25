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

require 'rubygems'
require 'active_support/core_ext'

module TimeExtender
  refine ActiveSupport::TimeWithZone do
    def method_missing(method, *args)
      if Time.respond_to?(method)
        self.to_time.send(:method, *args)
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
    puts "named #{string.format_to_my_name} on " + time.format_to_my_datetime("-06:00")
  end
end

RSpec.describe "time type class refinement experiment" do
  let(:cat) { Kitten.new }
  it "should be able to format string and time" do
    expect{ cat.name("meowth$$$",Time.now)}.to output("named meowth on Monday\n").to_stdout
  end
end
