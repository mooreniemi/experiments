require 'active_support/core_ext'
module A
  refine Time do
    def weekday
      self.strftime("%A")
    end
  end
end

module B
  using A

  puts Time.now.weekday # 1
  refine ActiveSupport::TimeWithZone do
    def method_missing(method, *args)
      # undefined puts Time.now.weekday # 2
      self.to_time.send(method.to_sym, args.first)
    end
  end

  puts Time.now.weekday # 3
end
