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
  local code = io.read()
  if code:sub(1, 1) == '$' then
   code = code:sub(2, -1)
   if code == 'lua' then
    mode = 'lua'
   elseif code == 'cmd' then
    mode = 'cmd'
   elseif code:sub(1, 3) == 'lwl' then
    local fn = code:sub(5, -1)
    local name = fn:gsub('.lua', '')
    local f = io.open(fn, "rb")
    if f then
     code = name..' = function()\n'..f:read("*all")..'\nend\n'..name..' = '..name..'()'
     f:close()
     red:lua(code)
    else
     print('Bad file '..code)
    end
   elseif code == 'quit' or code == 'q' then
    break
   end
  else
   f(red, code)
  end
 end
 red:close()
end
