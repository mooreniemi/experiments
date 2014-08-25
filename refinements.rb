module MyFormats
  MY_NAME_FORMAT = /[^A-Za-z0-9_]/
  MY_DATETIME_FORMAT = "%A"
end

module StringFormatter
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
end

class Kitten
  using TimeFormatter
end
