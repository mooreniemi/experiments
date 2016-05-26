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
					"#{array_index += 1}".center(5)
				elsif row == 0
					"#{potential_sums.shift}".center(5)
				else
					false
				end
			end

			table.each_with_index do |e, row, col|
				next if row == 0 && col == 0
				seeking = self[col - 1]
				num_in_col = table[0,row].to_i

				if seeking == num_in_col
					table[col,row] = true
				end
			end

			table.to_readable
		end
	end
end
