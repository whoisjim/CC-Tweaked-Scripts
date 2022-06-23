return {
 pos = {
  x = 0, --fb
  y = 0, --ud
  z = 0, --lr
  dir = 1 -- 1n, 2e, 3s, 4w
 },
 dirMap = {
  x = 0, n = 1, e = 2, s = 3, w = 4, d = 5, u = 6, r = 7,
  [0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6, [7] = 7
 },
 callbacks = {},
 callbackCount = 0,
 abort = false,
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
  if dir == 0 or dir == 7 then
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
  for i = 1, length do -- move loop
   if self.abort then self.abort = false break end
   if dir == 5 then -- down
    if dig then
     while turtle.detectDown() do
      turtle.digDown()
     end
    end
    if turtle.down() == true then
     self.pos.y = self.pos.y - 1
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
   elseif dir == 6 then -- up
    if dig then
     while turtle.detectUp() do
      turtle.digUp()
     end
    end
    if turtle.up() == true then
     self.pos.y = self.pos.y + 1
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
   else -- side to side
    self:turn(dir)
    if dig then
     while turtle.detect() do
      turtle.dig()
     end
    end
    if dir == 7 then
     if turtle.back() == true then
      if self.pos.dir == 1 then
       self.pos.x = self.pos.x - 1
      elseif self.pos.dir == 2 then
       self.pos.z = self.pos.z - 1
      elseif self.pos.dir == 3 then
       self.pos.x = self.pos.x + 1
      else -- self.pos.dir == 4
       self.pos.z = self.pos.z + 1
      end
     end
    else
     if turtle.forward() == true then
      if self.pos.dir == 1 then
       self.pos.x = self.pos.x + 1
      elseif self.pos.dir == 2 then
       self.pos.z = self.pos.z + 1
      elseif self.pos.dir == 3 then
       self.pos.x = self.pos.x - 1
      else -- self.pos.dir == 4
       self.pos.z = self.pos.z - 1
      end
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
   self.callbackCount = self.callbackCount + 1
   for callback in ipairs(self.callbacks) do
    if self.callbackCount % callback.loop == callback.trigger then
     callback.func(self)
    end
   end
  end -- move loop
 end,
 addCallback = function (self, callbackFunction, loopSize, callIndex)
  if callIndex == nil then
   callIndex = 0
  end
  table.insert(
   self.callbacks,
   {
    func = callbackFunction,
    loop = loopSize,
    index = callIndex,
   }
  )
 end,
 moveTo = function (self, dest, order, dig, digUp, digDown)
  if order == nil then
   order = {'x', 'z', 'y'}
  end
  if dest == nil then dest = {} end
  if dest[1] ~= nil then dest.x = dest[1] end
  if dest[2] ~= nil then dest.y = dest[2] end
  if dest[3] ~= nil then dest.z = dest[3] end
  local length = 0
  local dir = 'x'
  for i, axis in ipairs(order) do
   if dest[axis] == nil then
    length = 0
   else    
    length = dest[axis] - self.pos[axis]
   end
   if axis == 'x' then
    if length > 0 then
     dir = 'n'
    else
     dir = 's'
    end
   elseif axis == 'y' then 
    if length > 0 then
     dir = 'u'
    else
     dir = 'd'
    end
   elseif axis == 'z' then
    if length > 0 then
     dir = 'e'
    else
     dir = 'w'
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
 home = function(self)
  self:moveTo({0,0,0})
 end
}
