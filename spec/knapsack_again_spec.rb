Item = Struct.new(:name, :weight, :value)

stereo = Item.new('stereo', 4, 30)
guitar = Item.new('guitar', 1, 15)
laptop = Item.new('laptop', 3, 20)

items = [guitar, stereo, laptop]
capacity = 4

rows = items.size
columns = capacity

program = Array.new(rows) { Array.new(columns) { nil } }
program[0].each_with_index { |_, i| program[0][i] = items[0].value }

1.upto(items.size - 1) do |row_count|
  program[row_count].each_with_index do |_, i|
    current_weight = items[row_count].weight
    sub_capacity = i + 1

    previous_max = program[row_count-1][i]
    if current_weight > sub_capacity
      potential_new_max = previous_max
    elsif current_weight < sub_capacity
      remaining_weight = capacity - current_weight
      remaining_best = program[row_count-1][remaining_weight]
      potential_new_max = items[row_count].value + remaining_best
    else
      potential_new_max = items[row_count].value
    end

    program[row_count][i] = [
      previous_max,
      potential_new_max
    ].max
  end
end

program.each do |row|
  puts row.join(", ")
end

puts "highest value combo is #{program.last.last}"
