return {
 id = 0,
 protocall = 'red',
 timeout = 1,
 progress = 0,
 modumSide = '',
 mode = 'lua',
 libs = {
   mm = function ()
    mm = require('minemove')
   end
 },
 loadLib = function (self)
  for name, lib in pairs(self.libs) do
   if pcall(lib) then
    print('loaded '..name)
   else
    print('error'..name)
   end
  end 
 end,

 host = function (self, password)
  -- self:loadLib()
  self.modumSide = self.findSide()
  local massage = ''
  local id = 0
  rednet.open(self.modumSide)
  while true do
   while true do
    self.id, message = rednet.receive(self.protocall, timeout)
    if message == 'est' then
     print('got estb from '..self.id)
     rednet.send(self.id, 'ack', self.protocall)
     id, message = rednet.receive(self.protocall, timeout)
     if message == password and self.id == id then
      rednet.send(self.id, 'ack', self.protocall)
      print('got valid password')
      break
     else
      rednet.send(self.id, 'nck', self.protocall)
      print('got invalid password')
     end
    end
   end
   while true do
    id, message = rednet.receive(self.protocall, 0.1)
    if self.id == id then
     print('got message '..message)
     if message:sub(1, 3) == 'cls' then
      self.id = 0
     elseif message:sub(1, 3) == 'lua' then
      message = message:sub(5, -1)
      local f = loadstring(message)
      local e = false
      local m = ''
      e, m = pcall(f)
      if not e then
       print('error '..m..' '..message)
       rednet.send(self.id, 'err:'..m, self.protocall)
      else
       rednet.send(self.id, 'ack', self.protocall)
      end
     elseif message:sub(1, 3) == 'cmd' then
      shell.run(message:sub(5, -1))
     elseif message:sub(1, 3) == 'fch' then
     elseif message:sub(1, 3) == 'fhc' then
     end
    end
   end
  end
  rednet.close(self.modumSide)
 end,

 open = function (self, id, password)
  self.modumSide = self.findSide()
  local massage = ''
  rednet.open(self.modumSide)
  self.id = id
  local id = 0
  rednet.send(self.id, 'est', self.protocall)
  id, message = rednet.receive(self.protocall, timeout)
  if message == 'ack' and id == self.id then
   rednet.send(self.id, password, self.protocall)
   id, message = rednet.receive(self.protocall, timeout)
   if message == 'ack' and id == self.id then
    return true
   end
  end
  rednet.close(self.modumSide)
  return false
 end,

 close = function (self)
  rednet.send(self.id, 'cls', self.protocall)
  self.id = 0
  rednet.close(self.modumSide)
 end,

 lua = function (self, code)
  rednet.send(self.id, 'lua:'..code, self.protocall)
  while true do
   id, message = rednet.receive(self.protocall, timeout)
   if id == self.id then
    if message == 'ack' then
     break
    elseif message:sub(1, 3) == 'err' then
     print("Error "..message:sub(5, -1))
     break
    end
   end
  end
 end,

 command = function (self, code)
  rednet.send(self.id, 'cmd:'..code, self.protocall)
 end,

 filesend = function (self)
 end,

 fileget = function (self)
 end,

 findSide = function (self)
  return peripheral.getNames(peripheral.find("modem"))[1]
 end
}
