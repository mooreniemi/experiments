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

			table.to_readable

			col_header = table.row(0).to_a.map(&:to_i)

			table.each_with_index do |e, row_position, col_position|
				next if row_position == 0 || col_position == 0
				# we skip a row / column because of the col_header row / column
				num_from_subset = self[row_position - 1]
				col_label = table.column(col_position).first.to_i

				if num_from_subset == col_label
					table[row_position, col_position] = true
				elsif table[row_position - 1, col_position] == true
					table[row_position, col_position] = true
				else
					y = col_label - num_from_subset

					# we chop off the empty cell that gets coerced to 0 otherwise
					# and ignore anything that isn't in range
					next unless col_header[1..-1].include?(y)

					if table[row_position - 1, col_header.index(y)] == true
						table[row_position, col_position] = true
					end
				end
			end

			table.to_readable

			if table.column(col_header[1..-1].index(target) + 1).to_a.include?(true)
				table.send(:rows).reverse.each_with_index do |row,i|
					col_position = col_header[1..-1].index(target) + 1
					row_header = table.column(0).to_a.map(&:to_i)
					row_position = row_header[1..-1].index(row.first.to_i) + 1
					binding.pry
					#We start at the last row in this column; if it has a T and the row above has a T we go to the row above.
					#If the row above has an F then we take the number which is indexed by the current row and write it into our final output.
					#We then subtract this number from the column label to get the next column label. We jump to the new column label and go up a row.
					#Once again if there is a T there and there is an F above, then we write the number indexed by the row into our output and subtract it from the current column label to get the next column label.
					#We then jump to that column and go up a row again.
					#We keep doing this until we get to the top of the matrix, at this point the numbers we have written to the output will be our solution.
				end
			else
				false
			end
		end
	end
end
