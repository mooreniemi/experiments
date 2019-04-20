def sieve(n)
  prime = Array.new(n+1) { true }
  p = 2
  while (p*p) <= n
    if prime[p]
      (p*2).step(n+1, p).with_index do |i|
        prime[i] = false
      end
    end
    p += 1
  end
  prime.map.with_index { |e,i| i if e }.compact
end
