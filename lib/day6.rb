@cycle = ->(a) do
  hi_bank_i = a.index(a.max)
  redist = a[hi_bank_i]
  a[hi_bank_i] = 0

  cyc = (0..a.size - 1).cycle
  (i = cyc.next) until i == hi_bank_i

  while redist > 0
    redist -= 1
    a[cyc.next] += 1
  end

  a
end

@a = [0,2,7,0]
@b = [4, 10, 4, 1, 8, 4, 9, 14, 5, 1, 14, 15, 0, 15, 3, 5]

count_loops = ->(a) do
  a = @cycle.(a)
  memo = { a.dup => 1 }
  seen = false
  loops = 1
  until seen
    a = @cycle.(a)
    loops += 1
    memo[a].nil? ? memo[a.dup] = 1 : seen = true
  end
  loops
end

p count_loops.(@a)
p count_loops.(@b)
