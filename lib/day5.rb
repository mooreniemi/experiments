@a = [0,3,0,1,-3]
def jumper(ins,i,j,step)
  j = ins[i]
  return step if j.nil?

  ins[i] >= 3 ? ins[i] -= 1 : ins[i] += 1
  i = i + j

  step += 1
  jumper(ins,i,j,step)
end
p jumper(@a,@a.first,@a[@a.first],0)

@input = File.read('../../Downloads/input').split("\n").map(&:to_i)

i = @input.first
step = 0

while true
  step += 1

  j = @input[i]
  break step if j.nil?

  @input[i] += 1
  i = i + j
end

p step

# reset for other runner
@input = File.read('../../Downloads/input').split("\n").map(&:to_i)
