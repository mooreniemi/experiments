def is_subsequence?(s1,s2,m=s1.length,n=s2.length)
  return true if m == 0
  return false if n == 0

  #p "#{s1[m-1]} == #{s2[n-1]}"
  if s1[m-1] == s2[n-1]
    is_subsequence?(s1,s2,m-1,n-1)
  else
    is_subsequence?(s1,s2,m,n-1)
  end
end

p is_subsequence?("gksrek","geeksforgeeks")
