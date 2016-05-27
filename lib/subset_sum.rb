require 'matrix'
class Matrix
	def []=(i, j, x)
		@rows[i][j] = x
	end
	def to_readable
		i = 0
		self.each do |number|
			print number.to_s + " "
			i+= 1
			if i == self.column_size
				print "\n"
				i = 0
			end
		end
	end
end

module SubsetSum
	refine Array do
		def subset_sum_to(target)
			return [] if self.empty?

			all_summed = self.reject{|n| n <= 0}.reduce(0, :+)
			tiniest_sum = self.reject{|n| n > 0}.reduce(0, :+)
			range = tiniest_sum.abs + all_summed.abs
			potential_sums = (tiniest_sum..all_summed).to_a
			array_index = -1

			table = Matrix.build(self.length + 1, range + 2) do |row, col|
				if col == 0 && row == 0
					" ".center(5)
				elsif col == 0
					"#{self[array_index += 1]}".center(5)
				elsif row == 0
					"#{potential_sums.shift}".center(5)
				else
					false
				end
			end

			table.each_with_index do |e, row_position, col_position|
				next if row_position == 0 || col_position == 0
        # we skip a row / column because of the header row / column
        num_from_subset = self[row_position - 1]
        col_label = table.column(col_position).first.to_i

        if num_from_subset == col_label
          table[row_position, col_position] = true
        elsif table[row_position - 1, col_position] == true
          table[row_position, col_position] = true
        else
          sums = table.row(0).to_a.map(&:to_i)
          y = col_label - num_from_subset

          # we chop off the empty cell that gets coerced to 0 otherwise
          # and ignore anything that isn't in range
          next unless sums[1..-1].include?(y)

          if table[row_position - 1, sums.index(y)] == true
            table[row_position, col_position] = true
          end
        end
			end

			table.to_readable
		end
	end
end
