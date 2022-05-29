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
    if message == 'estb' then
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
     if message == 'cls' then
      self.id = 0
     elseif message == 'lua' then
      id, message = rednet.receive(self.protocall, 0.1)
      local f = loadstring(message)
      local e = false
      local m = ''
      e, m = pcall(f)
      if not e then
       print('error '..m..' '..message)
      end
     elseif message == 'cmd' then
      id, message = rednet.receive(self.protocall, 0.1)
      shell.run(message)
     elseif message == 'fch' then
     elseif message == 'fhc' then
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
  rednet.send(self.id, 'estb', self.protocall)
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
  rednet.send(self.id, 'lua', self.protocall)
  rednet.send(self.id, code, self.protocall)
 end,

 command = function (self, code)
  rednet.send(self.id, 'cmd', self.protocall)
  rednet.send(self.id, code, self.protocall)
 end,

 filesend = function (self)
 end,

 fileget = function (self)
 end,

 findSide = function (self)
  return peripheral.getNames(peripheral.find("modem"))[1]
 end
}
