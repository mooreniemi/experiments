require 'spec_helper'

#int primryDiagonaSum = 0, secondaryDiagonalSum = 0;
#int size = squarematrix.length -1;
#for(int i = 0; i<squarematrix.length; i++){

#primryDiagonaSum += squarematrix[i][i];
#secondaryDiagonalSum+= squarematrix[i][size-i];

class Array
	def diagonal_diff(n)
		primary_sum = 0
		secondary_sum = 0
		matrix = self.each_slice(n).to_a
		size = matrix.length - 1

		(0..size).step(1) do |i|
			primary_sum += matrix[i][i]
			secondary_sum += matrix[i][size-i]
		end

		(primary_sum - secondary_sum).abs
	end
end

describe "#diagonal_diff" do
	let(:array) {[11, 2, 4, 4, 5, 6, 10, 8, -12]}
	let(:n) {3}
	it 'returns 15 array' do
		expect(array.diagonal_diff(n)).to eq(15)
	end
end
