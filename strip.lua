local fun = require("fun")
x = tonumber(arg[1]) - 1
y = tonumber(arg[2])
z = tonumber(arg[3])
l3 = arg[4]
if l3 == nil then l3 = 'f' end
if string.lower(l3) == 'true'
or string.lower(l3) == 't' then
 l3 = true
else
 l3 = false
end
if l3 then
 z = math.ceil(z / 3)
end
for k = 1,z do
 if l3 and k == 1 then
  turtle.digDown()
  turtle.down()
  turtle.digDown()
 elseif l3 then
  turtle.digDown()
  turtle.down()
  turtle.digDown()
  turtle.down()
  turtle.digDown()
 end
 turtle.digDown()
 turtle.down()
 for j = 1,y do
  for i = 1,x do
   fun.forward(l3)
  end
  if j == y then
   print('last')
  elseif (((y+1) * k) + j) % 2 == y % 2 then
   turtle.turnRight()
   fun.forward(l3)
   turtle.turnRight()
  else
   turtle.turnLeft()
   fun.forward(l3)
   turtle.turnLeft()
  end
 end
 turtle.turnLeft()
 turtle.turnLeft()
end
