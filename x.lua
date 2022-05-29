red = require('red')
io.write('id?> ')
id = tonumber(io.read())
io.write('password?> ')
password = io.read()
if red:open(id, password) then
 local f = red.lua
 local mode = 'lua'
 while true do
  if mode == 'lua' then
   f = red.lua
  elseif mode == 'cmd' then
   f = red.command
  end
  io.write(mode..'@'..red.id..'> ')
  code = io.read()
  if code == '$lua' then
   mode = 'lua'
  elseif code == '$cmd' then
   mode = 'cmd'
  elseif code == '$quit' then
   break
  else
   f(red, code)
  end
 end
 red:close()
end
