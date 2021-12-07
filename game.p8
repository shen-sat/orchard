pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
  cam = {
    x = 0,
    y = 0
  }
end

function _update()
  -- navigate orchard
  if btnp(1) then 
    cam.x += 8
  elseif btnp(0) then
    cam.x -= 8
  elseif btnp(2) then
    cam.y -= 8
  elseif btnp(3) then
    cam.y += 8
  end
  camera(cam.x,cam.y)
end

function _draw()
  cls()
  rect(0,0,127,127,5) --border
end

