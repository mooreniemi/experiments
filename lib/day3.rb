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

# ok but how do we reach our target?
target = 361527

get_spiral_coords_of = ->(t) do
  highest_so_far = 0
  spiral_level = 0
  built_string = ""
  until highest_so_far >= t
    built_string += spiral.(spiral_level)
    built_spiral = str_to_coords.(built_string)
    highest_so_far = built_spiral.size
    spiral_level += 1
  end
  built_spiral[t - 1]
end

# p get_spiral_coords_of.(9)
# p get_spiral_coords_of.(10)
# p get_spiral_coords_of.(25)
# p get_spiral_coords_of.(27)
spiral_coords = get_spiral_coords_of.(target)
p spiral_coords

# we need the manhattan distance of the coordinates
manhattan_distance = ->(coords) { coords[0].abs + coords[1].abs }

p manhattan_distance.(spiral_coords)

# location number => coordinates (with [0,0] at center which is 1)
as_location_mapping = ->(coords) { coords.each_with_object({}).with_index {|(e,h), i| h[i + 1] = e } }

p as_location_mapping.(str_to_coords.(spiral.(0)))
