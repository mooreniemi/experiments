require 'pry'

require 'tree'
require 'tree_data'
include TreeData

describe "Tree" do
  describe "#children" do
    it 'gives left and right together' do
      expect(fb_tree.children.size).to eq(2)
    end
  end
  describe "#preorder" do
    it 'outputs values' do
      # [ 6, 3, 5, 9, 2, 7, 1, 4, 0, 8 ]
      expect{ fb_tree.preorder {|n| puts "#{n.value}" } }.
        to output("6\n3\n5\n9\n2\n7\n1\n4\n0\n8\n").to_stdout
    end
  end
  describe "#inorder" do
    it 'outputs values' do
      # [ 9, 5, 2, 7, 3, 1, 6, 4, 8, 0 ]
      expect { fb_tree.inorder {|n| puts "#{n.value}" } }.
        to output("9\n\n5\n2\n7\n\n\n\n3\n1\n\n\n6\n4\n8\n\n0\n\n\n").to_stdout
    end
  end
  describe "#postorder" do
    it 'outputs values' do
      # [ 9, 7, 2, 5, 1, 3, 8, 0, 4, 6 ]
      expect{ fb_tree.postorder {|n| puts "#{n.value}" } }.
        to output("9\n\n7\n\n2\n\n5\n\n1\n\n3\n\n8\n\n0\n\n4\n\n6\n").to_stdout
    end
  end

  describe "columning" do
    context "using coordinates strategy" do
      describe "#with_coordinates" do
        let(:base_tree) { Node.new(value: 1) }
        it 'assigns base_tree [0,0]' do
          puts base_tree.with_coordinates
        end
        it 'assigns left child [1,1]' do
          base_tree.left = Node.new(value: 2)
        end
      end
    end

    context "using padding strategy" do
      # TODO non-coordinates strategy
      # bfs to get rows and height and keep placeholders
      # get max width based on height from bfs
      # pad all rows

      describe "#bfs_for(element)" do
        it 'does BFS' do
          expect(fb_tree.bfs_for(7)).to be true
          expect(fb_tree.bfs_for(17)).to be false
        end

        it 'populates rows' do
          sticky_tree = fb_tree
          sticky_tree.bfs_for(99)
          rows = sticky_tree.as_rows

          # TODO need to partition list
          height = 5
          puts rows.slice!(0..2**0)
          puts "\n"
          (height - 1).times do |n|
            n += 1
            puts rows.slice!(0..2**n + 1)
            puts "\n"
          end

          expect(rows.uniq.size).to eq(5)
        end
      end

      it 'represents trees as levels' do
        top = [nil, nil, 6, nil, nil]
        middle = [nil, 3, nil, nil, 4, nil]
        bottom = [5, nil, 1, nil, nil, 0]

        first_column = [top[0]] + [middle[0]] + [bottom[0]]
        second_column = [top[2]] + [middle[2]] + [bottom[2]]
        expect(first_column).to eq([nil, nil, 5])
        expect(second_column).to eq([6, nil, 1])
      end
    end
  end
end
