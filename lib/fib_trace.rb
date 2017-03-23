fib = Hash.new {|h, k| h[k] = h[k-1] + h[k-2] }.merge(0 => 0, 1 => 1)

set_trace_func proc { |event, file, line, id, binding, classname|
  unless classname
    vars = binding.local_variables.each_with_object({}) do |lv, hash|
      hash[lv] = binding.local_variable_get(lv)
    end
    printf "%8s %8s %s:%-2d %10s %8s %8s\n", Time.now, event, file, line, id, classname, vars
  end
}

puts "\n fib[5]:\n"
fib[5]

puts "\n fib[6]:\n"
fib[6]

