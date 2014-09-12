require 'pry'

module DataForIO
  ARRAY = [
    {'id'=> 1 ,'parentid' =>  0},
    {'id'=> 2 ,'parentid' =>  1},
    {'id'=> 3 ,'parentid' =>  1},
    {'id'=> 4 ,'parentid' =>  2},
    {'id'=> 5 ,'parentid' =>  0},
    {'id'=> 6 ,'parentid' =>  0},
    {'id'=> 7 ,'parentid' =>  4}
  ]

  NESTED = [
    {
      'id' => 1,
      'parentid' => 0,
      'children' => [
        {
          'id' => 2,
          'parentid' => 1,
          'children' => [
            {
              'id' => 4,
              'parentid' => 2,
              'children' => [
                {
                  'id' => 7,
                  'parentid' => 4
                }
              ]
            }
          ]
        },
        {
          'id' => 3,
          'parentid' => 1
        }
      ]
    },
    {
      'id' => 5,
      'parentid' => 0
    },
    {
      'id' => 6,
      'parentid' => 0
    }
  ]
end

module ArrayToTree
  refine Array do
    def to_tree
      return self if self.size <= 1
      parent_ids = self.inject([]) {|a,e| a << e["parentid"] ; a}
      result = []
      self.each do |e|
        children = parent_ids.include?(e['id']) ? self.select{|node| node['parentid'] == e['id']} : []
        result << e.merge({'children' => children }) unless children.empty?
      end
      return result
    end
  end
end

class Tree
  using ArrayToTree

  attr_accessor :data

  def initialize(array)
    @data = array.to_tree
  end
end

RSpec.describe "tree conversion" do
  context "building toward example" do
    it "returns empty array" do
      expect(Tree.new([]).data).to eq([])
    end
    it "returns childless" do
      expect(Tree.new([{'id' => 1, 'parentid' => 0}]).data).to eq([{'id' => 1, 'parentid' => 0}])
    end
    it "returns parent with 1 child nested" do
      expect(Tree.new([{'id' => 1, 'parentid' => 0},{'id'=> 2 ,'parentid' => 1}]).data).to eq([{'id' => 1, 'parentid' => 0,
                                                                                                'children' => [{'id'=> 2 ,'parentid' =>  1}]}])
    end
  end

  context "with full example" do
    let(:tree) { Tree.new(DataForIO::ARRAY) }

    it "returns nested representation of original array" do
      pending "final implementation"
      expect(tree.data).to eq(DataForIO::NESTED)
    end
  end
end
