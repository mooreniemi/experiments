require 'benchmark/memory'

    D = proc {|x| p "#{x} is dead".freeze }
    L = proc {|x| p "#{x} is live".freeze }
Benchmark.memory do |x|
  x.report("SDM") do
    next_state_string = "DDDLDDDLLD".freeze

    number_of_live_neighbors = 3

    LIVENESS_OFFSET = 4

    chosen_proc_name = next_state_string[number_of_live_neighbors + LIVENESS_OFFSET]

    Object.const_get(chosen_proc_name).call(1)
  end

  x.report("TDM") do
    next_state_array = [["D", "D", "D", "L", "D"], ["D", "D", "L", "L", "D"]].freeze

    number_of_live_neighbors = 3

    LIVENESS = 0

    chosen_proc_name = next_state_array[LIVENESS][number_of_live_neighbors]

    Object.const_get(chosen_proc_name).call(1)
  end

  x.compare!
end
