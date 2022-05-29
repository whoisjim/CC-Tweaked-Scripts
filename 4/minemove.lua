return {
 pos = {
  x = 0,
  y = 0,
  z = 0,
  dir = 'n' -- n, e, s, w
 },
 dirMap = {
  n = 1, e = 2, s = 3, w = 4, d = 5, u = 6,
  [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6
 },
 turn = function(self, dir)
  dir = self.dirMap[dir]
  if math.abs(dir - self.pos.dir) == 2 then
   turtle.turnLeft()
   turtle.turnLeft()
  elseif (dir = 4 and self.pos.dir == 1) then
   turtle.turnLeft()
  elseif (dir = 1 and self.pos.dir == 4) then
   turtle.turnRight()
  elseif dir - self.pos.dir > 0 then
   turtle.turnLeft()
  elseif dir - self.pos.dir < 0 then
   turtle.turnRight()
  end
  self.pos.dir = dir
 end,
 move = function(self, dir, length, dig, digUp, digDown)
  dir = self.dirMap[dir]
  if dir == 5 then -- down
   for i = 1, length then
    if dig then
     while turtle.detectDown() do
      turtle.digDown()
     end
    end
    if turtle.down() == true then
     z = z - 1
    end
    if digDown then
     while turtle.detectDown() do
      turtle.digDown()
     end
    end
    if digUp then
     while turtle.detectUp() do
      turtle.digUp()
     end
    end
   end
  elseif dir == 6 then -- up
   for i = 1, length then
    if dig then
     while turtle.detectUp() do
      turtle.digUp()
     end
    end
    if turtle.up() == true then
     z = z + 1
    end
    if digDown then
     while turtle.detectDown() do
      turtle.digDown()
     end
    end
    if digUp then
     while turtle.detectUp() do
      turtle.digUp()
     end
    end
   end
  else -- side to side
   self:turn(dir)
   for i = 1, length then
    if dig then
     while turtle.detect() do
      turtle.dig()
     end
    end
    if turtle.forward() == true then
     if dir == 1 then
      x = x + 1
     elseif dir == 2 then
      y = y + 1
     elseif dir == 3 then
      x = x - 1
     else -- dir == 4
      y = y - 1
     end
    end
    if digDown then
     while turtle.detectDown() do
      turtle.digDown()
     end
    end
    if digUp then
     while turtle.detectUp() do
      turtle.digUp()
     end
    end
   end
  end
 end,
}