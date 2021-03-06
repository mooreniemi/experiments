require 'spec_helper'
require 'stackprof'
require 'ruby-prof'
require 'quicksort'
require 'rantly/rspec_extensions'

describe '#quicksort' do
  context 'profiling' do
    let(:profiled_array) { (0..33).to_a.shuffle }
    it 'stackprof' do
      StackProf.run(mode: :object, out: 'tmp/stackprof-object-quicksort.dump', interval: 1) do
        quicksort(profiled_array)
      end
    end
    it 'ruby-prof' do
      RubyProf.start
      quicksort(profiled_array)
      result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT)
    end
  end
  context 'homework' do
    let(:homework_array) do
      File.read('./spec/support/quicksort_nums.txt').
        split("\r\n").map(&:to_i)
    end
    let(:test_case_array) do
      File.read('./spec/support/qs100.txt').
        split("\r\n").map(&:to_i)
    end
    let(:sorted_test_case_array) { test_case_array.sort }
    let(:sorted_homework_array) { homework_array.sort }

    it 'sorts homework array' do
      expect(quicksort(homework_array, &median_element_partition)).
        to eq(sorted_homework_array)
    end
    it 'counts comparisons' do
      # add $comparisons += m - 1, where m is subarray length
      # on each recursive call of quicksort to count
      $comparisons = 0
      expect(quicksort(test_case_array, &median_element_partition)).
        to eq(sorted_test_case_array)
      puts "# of comparisons: #{$comparisons}"
    end
  end

  it 'sorts an array' do
    array = [3, 7, 8, 5, 2, 1, 9, 5, 4]
    sorted = array.sort
    expect(quicksort(array)).to eq(sorted)
  end
  it 'sorts an array (0..34)' do
    array = (0..34).to_a.shuffle
    sorted = array.sort
    expect(quicksort(array)).to eq(sorted)
  end
  it 'sorts some arrays' do
    arrays = [[0],[9,8],[7,6,5],[4,3,2,1]]
    arrays.each do |array|
      expect(quicksort(array)).to eq(array.sort)
    end
  end

  context 'can take different partition blocks' do
    it 'puts pivot in correct sorted position' do
      array = [8,2,4,5,7,1]
      sorted = array.sort
      expect(quicksort(array, &median_element_partition)).to eq(sorted)
    end
    it 'which all sort correctly' do
      arrays = [[0],[9,8],[7,6,5],[4,3,2,1]]
      arrays.each do |array|
        sorted = array.sort
        expect(quicksort(array, &median_element_partition)).to eq(sorted)
      end
      arrays = [[0],[9,8],[7,6,5],[4,3,2,1]]
      arrays.each do |array|
        sorted = array.sort
        expect(quicksort(array, &last_element_partition)).to eq(sorted)
      end
    end
  end
  it 'REALLY sorts an array' do
    property_of {
      array(100) { call([:range,0,10_000]) }
    }.check { |a|
      sorted = a.sort
      expect(quicksort(a)).to eq(sorted)
    }
    property_of {
      array(1000) { call([:range,0,10_000]) }
    }.check { |a|
      sorted = a.sort
      expect(quicksort(a)).to eq(sorted)
    }
    property_of {
      array(10_000) { call([:range,0,10_000]) }
    }.check { |a|
      sorted = a.sort
      expect(quicksort(a)).to eq(sorted)
    }
  end
end

describe '#partition' do
  it 'partitions correctly' do
    _, _, partitioned = partition([3,4,2,1],0,3)
    expect(partitioned).to eq([1,2,3,4])
  end
  describe 'property tests' do
    it 'puts pivot in correct sorted position' do
      property_of {
        array = array(1000) { call([:range,0,10_000]) }
        pivot = array.first
        sorted = array.sort
        pivot_index = sorted.index(pivot)

        [pivot_index, pivot, array]
      }.check { |(pi,p,a)|
        _, _, partitioned = partition(a,0,a.length-1)
        partitioned_position = partitioned.index(p)

        expect(partitioned_position).to eq(pi)
      }
    end
    it 'left of pivot is LT, right of pivot is GT' do
      property_of {
        array(1000) { call([:range,0,10_000]) }
      }.check { |a|
        pivot = a.first
        _, pivot_index, partitioned = partition(a,0,a.length-1)
        expect(partitioned[0..pivot_index].all? { |e| e <= pivot}).to eq(true)
        expect(partitioned[pivot_index..-1].all? { |e| e >= pivot}).to eq(true)
      }
    end
  end
end

describe '#random_partition' do
  describe 'property tests' do
    it 'puts pivot in correct sorted position' do
      property_of {
        array = array(1000) { call([:range,0,10_000]) }
        pivot = array.first
        sorted = array.sort
        pivot_index = sorted.index(pivot)

        [pivot_index, pivot, array]
      }.check { |(pi,p,a)|
        _, _, partitioned = random_partition(a,0,a.length-1)
        partitioned_position = partitioned.index(p)

        expect(partitioned_position).to eq(pi)
      }
    end
    it 'left of pivot is LT, right of pivot is GT' do
      property_of {
        array(1000) { call([:range,0,10_000]) }
      }.check { |a|
        pivot = a.first
        _, pivot_index, partitioned = random_partition(a,0,a.length-1)
        expect(partitioned[0..pivot_index].all? { |e| e <= pivot}).to eq(true)
        expect(partitioned[pivot_index..-1].all? { |e| e >= pivot}).to eq(true)
      }
    end
  end
end
