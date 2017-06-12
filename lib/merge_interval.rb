class Interval
  attr_accessor :start, :end
  def initialize(s=0, e=0)
    @start = s
    @end = e
  end
end

def merge(intervals)
  return intervals if intervals.empty? || intervals.size == 1

  sorted_intervals = intervals.sort_by(&:start)
  new_intervals = [] << sorted_intervals.shift

  until sorted_intervals.empty?
    a = new_intervals.pop
    b = sorted_intervals.shift

    if a.end >= b.start
      new_intervals << Interval.new(a.start, [a.end, b.end].max)
    else
      new_intervals << a << b
    end
  end

  new_intervals
end
