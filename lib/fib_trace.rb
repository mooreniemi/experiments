class Hash
  def []=(k,v)
    p "before: #{self}"
    self.store(k,v)
    p "after: #{self}"
  end
end

# we're gonna pry in to assigment using
# the above monkey patch ---v
fib = Hash.new {|h, k| h[k] = h[k-1] + h[k-2] }.merge(0 => 0, 1 => 1)

# if we want some extra info, but it won't be as useful
if ENV['TRACE_FUNC']
  set_trace_func proc { |event, file, line, id, binding, classname|
    unless classname
      vars = binding.local_variables.each_with_object({}) do |lv, hash|
        hash[lv] = binding.local_variable_get(lv)
      end
      printf "%8s %8s %s:%-2d %10s %8s %8s\n", Time.now, event, file, line, id, classname, vars
    end
  }
end

puts "\n fib[5]:\n"
fib[5]

puts "\n fib[6]:\n"
fib[6]

fib = Hash.new {|h, k| h[k] = h[k-1] + h[k-2] }.merge(0 => 0, 1 => 1)
begin
  overload = 3940
  puts "\n fib[#{overload}] (is too much!):\n"
  fib[overload]
rescue SystemStackError => e
  p "backtrace line count: #{e.backtrace.count}"
end
