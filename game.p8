pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
  cam = {
    x = 0,
    y = 0
  }

  selected_card = {
    width = 2 * 8,
    height = 3 * 8,
    col = 7,
    x0 = 0,
    y0 = 0,
    x1 = function(self)
      return calculate_x1(self.x0, self.width)
    end,
    y1 = function(self)
      return calculate_y1(self.y0,self.height)
    end
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
  rect(selected_card.x0,selected_card.y0,selected_card:x1(),selected_card:y1(),selected_card.col)
  -- rect(20,20,40,40,14)
end

function calculate_x1(x0, width)
  return x0 + width - 1
end

function calculate_y1(y0, height)
  return y0 + height - 1
end

