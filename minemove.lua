return {
 pos = {
  x = 0,
  y = 0,
  z = 0,
  dir = 1 -- 1n, 2e, 3s, 4w
 },
 dirMap = {
  x = 0, n = 1, e = 2, s = 3, w = 4, d = 5, u = 6,
  [0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6
 },
 setOrigin = function(self, x, y, z, dir)
  dir = self.dirMap[dir]
  if x == nil then x = 0 end
  if y == nil then y = 0 end
  if z == nil then y = 0 end
  if 4 < dir or dir < 1 then dir = nil end
  if dir == nil then dir = 1 end
  self.pos.x = x
  self.pos.y = y
  self.pos.z = z
  self.pos.dir = dir
 end,
 turn = function(self, dir)
  dir = self.dirMap[dir]
  if dir == 0 then
   return
  elseif math.abs(dir - self.pos.dir) == 2 then
   turtle.turnLeft()
   turtle.turnLeft()
  elseif (dir == 4 and self.pos.dir == 1) then
   turtle.turnLeft()
  elseif (dir == 1 and self.pos.dir == 4) then
   turtle.turnRight()
  elseif dir - self.pos.dir > 0 then
   turtle.turnRight()
  elseif dir - self.pos.dir < 0 then
   turtle.turnLeft()
  end
  self.pos.dir = dir
 end,
 move = function(self, dir, length, dig, digUp, digDown)
  dir = self.dirMap[dir]
  if dir == 5 then -- down
   for i = 1, length do
    if dig then
     while turtle.detectDown() do
      turtle.digDown()
     end
    end
    if turtle.down() == true then
     self.pos.z = slf.pos.z - 1
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
   for i = 1, length do
    if dig then
     while turtle.detectUp() do
      turtle.digUp()
     end
    end
    if turtle.up() == true then
     self.pos.z = self.pos.z + 1
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
   for i = 1, length do
    if dig then
     while turtle.detect() do
      turtle.dig()
     end
    end
    if turtle.forward() == true then
     if dir == 1 then
      self.pos.x = self.pos.x + 1
     elseif dir == 2 then
      self.pos.y = self.pos.y + 1
     elseif dir == 3 then
      self.pos.x = self.pos.x - 1
     else -- dir == 4
      self.pos.y = self.pos.y - 1
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
 moveTo = function (self, dest, order, dig, digUp, digDown)
  if order == nil then
   order = {'x', 'y', 'z'}
  end
  if dest == nil then
   dest = {x = 0, y = 0, z = 0}
  end
  local length = 0
  local dir = 'x'
  for i, axis in ipairs(order) do
   length = dest[axis] - self.pos[axis]
   if axis == 'x' then
    if length > 0 then
     dir = 'n'
    else
     dir = 's'
    end
   elseif axis == 'y' then 
    if length > 0 then
     dir = 'e'
    else
     dir = 'w'
    end
   elseif axis == 'z' then
    if length > 0 then
     dir = 'u'
    else
     dir = 'd'
    end
   end
   if length ~= 0 then
    self:move(dir, math.abs(length), dig, digUp, digDown)
   end
  end
 end,
 moveList = function(self, posList, order, dig, digUp, digDown)
  for i, pos in posList do
   self:moveTo(pos, order, dig, digUp, digDown)
  end
 end,
}
