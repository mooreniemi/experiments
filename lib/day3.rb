# spiral routes as strings of directions
one = "RULLDDRR"
two = "RUUULLLLDDDDRRRR"
three = "RUUUUULLLLLLDDDDDDRRRRRR"

odd = ->(i) { i * 2 + 1 }
even = ->(i) { i * 2 + 2 }

# how do we generate new strings?
spiral = ->(i) { "R" + ("U" * odd.(i)) + ("L" * even.(i)) + ("D" * even.(i)) + ("R" * even.(i)) }

p one == spiral.(0)
p two == spiral.(1)
p three == spiral.(2)

# coordinates from a direction
r = [1,0]
l = [-1,0]
u = [0,1]
d = [0,-1]

# how do the strings translate into coordinates?
right = ->(a) { a[0] += 1 ; a }
left = ->(a) { a[0] -= 1 ; a }
up = ->(a) { a[1] += 1 ; a }
down = ->(a) { a[1] -= 1 ; a }

p r == right.([0,0])
p l == left.([0,0])
p u == up.([0,0])
p d == down.([0,0])

str_to_coords = ->(s) do
  mapping = { R: right,
              L: left,
              U: up,
              D: down }
  coords = []
  s.chars.each_with_object([0,0]) {|c,a|  coords << mapping[c.to_sym].(a).dup }
  [[0,0]] + coords
end

# spirals nest inside each other
# p str_to_coords.(one)
# p str_to_coords.(one + two)
p str_to_coords.(one + two + three) == str_to_coords.(spiral.(0) + spiral.(1) + spiral.(2))

# location number => coordinates (with [0,0] at center which is 1)
p str_to_coords.(spiral.(0)).each_with_object({}).with_index {|(e,h), i| h[i + 1] = e }
