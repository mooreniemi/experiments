#array increases up to a certain point then starts decreasing again
#1, 2, 3, 7, 6, 5
#find peak within log n time
class Array
	def find_max
		pivot = (self.length / 2)
		list = self
		max = nil
		while max.nil?
			# fetching in case we dont have any more elements higher or lower
			if list[pivot] >= list.fetch(pivot - 1,0) && list[pivot] >= list.fetch(pivot + 1,0)
				max = list[pivot]
			else
				# if increasing still
				if list[pivot] > list.fetch(pivot - 1, 0)
					list = list[pivot..-1]
					pivot = (list.length / 2)
				else
					list = list[0..pivot - 1]
					pivot = (list.length / 2)
				end
			end
		end
		max
	end
end
