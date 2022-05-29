return {
forward = function(threeLevel)
 while turtle.detect() do
  turtle.dig()
 end
 turtle.forward()
 if threeLevel then
  while turtle.detectUp() do
   turtle.digUp()
  end
  turtle.digDown()
 end
end
}
