require 'pry'

# the one-liner winner is
# def snail(array)
#   array.empty? ? [] : array.shift + snail(array.transpose.reverse)
# end

class Trailer
  def initialize(collection)
    @collection = collection
    @slime = []
  end

  def snail
    return @slime if @collection.flatten.empty?

    until @collection.flatten.empty?
      @slime << right_corner
      clear_right_corner!
      @slime << left_corner
      clear_left_corner!
    end

    @slime.flatten
  end

  private
  def clear_right_corner!
    @collection.delete_at(0) # delete top row
    @collection = @collection.each {|a| a.delete_at((a.length - 1)) } # delete rightmost column
  end
  def clear_left_corner!
    @collection.delete_at((@collection.length - 1)) # delete bottom row
    @collection = @collection.each {|a| a.delete_at((0)) } # delete leftmost column
  end
  def right_corner
    first_row[0...-1] + last_column
  end

  def left_corner
    last_row.reverse[0...-1] + first_column.reverse
  end

  def last_column
    @collection.inject([]) {|a,e| a << e.last }
  end

  def first_row
    @collection.first || []
  end

  def first_column
    @collection.inject([]) {|a,e| a << e.first }
  end

  def last_row
    @collection.last || []
  end
end

RSpec.describe "snail trail algorithm" do
  context "helper methods" do
    it "takes right corners" do
      expect(Trailer.new([[1,2],[3,4]]).send(:right_corner)).to eq([1,2,4])
    end
    it "takes left corners" do
      expect(Trailer.new([[1,2],[3,4]]).send(:left_corner)).to eq([4,3,1])
    end
  end

  context "main #snail" do
    it "returns empty array" do
      expect(Trailer.new([[]]).snail).to eq([])
    end
    it "handles 2x2" do
      expect(Trailer.new([[1,2],
                          [3,4]]).snail).to eq([1,2,4,3])
    end
    it "handles 3x3" do
      expect(Trailer.new([[1,2,3],
                          [4,5,6],
                          [7,8,9]]).snail).to eq([1,2,3,6,9,8,7,4,5])
    end
    it "handles 4x4" do
      expect(Trailer.new([[1,2,3,1],
                          [4,5,6,4],
                          [7,8,9,7],
                          [7,8,9,7]]).snail).to eq([1,2,3,1,4,7,7,9,8,7,7,4,5,6,9,8])
    end
    it "handles 5x5" do
      expect(Trailer.new([[1,2,3,4,5],
                          [6,7,8,9,10],
                          [11,12,13,14,15],
                          [16,17,18,19,20],
                          [21,22,23,24,25]]).snail).to eq([1,2,3,4,5,10,15,20,25,24,23,22,21,16,11,6,7,8,9,14,19,18,17,12,13])
    end
  end
end
