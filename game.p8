pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
  tile_size = 16

  cam = {
    x0 = 0,
    y0 = 0,
    width = 128,
    height = 128,
    x1 = function(self)
      return calculate_x1(self.x0, self.width)
    end,
    y1 = function(self)
      return calculate_y1(self.y0, self.height)
    end
  }

  one = {
    sprite = 0
  }
  two = {
    sprite = 1
  }
  three = {
    sprite = 2
  }
  four = {
    sprite = 3
  }
  five = {
    sprite = 4
  }
  six = {
    sprite = 5
  }

  orchard = {
    x0 = 0,
    y0 = 0,
    x1 = function(self)
      return calculate_x1(self.x0, self.width)
    end,
    y1 = function(self)
      return calculate_y1(self.y0, self.height)
    end,
    height = 128,
    width = 128
  }

  selected_card = {
    width = 2 * tile_size,
    height = 3 * tile_size,
    col = 7,
    fruits = {one,two,three,four,five,six},
    vertical_slots = function(self) 
      return {
        { x = self.x0, y = self.y0 },
        { x = self.x0 + tile_size, y = self.y0 },
        { x = self.x0, y = self.y0 + tile_size },
        { x = self.x0 + tile_size, y = self.y0 + tile_size },
        { x = self.x0, y = self.y0 + (tile_size * 2) },
        { x = self.x0 + tile_size, y = self.y0 + (tile_size * 2) }
      }
    end,
    horizontal_slots = function(self) 
      return {
        { x = self.x0, y = self.y0 },
        { x = self.x0 + tile_size, y = self.y0 },
        { x = self.x0 + (tile_size * 2), y = self.y0 },
        { x = self.x0, y = self.y0 + tile_size },
        { x = self.x0 + tile_size, y = self.y0 + tile_size },
        { x = self.x0 + (tile_size * 2), y = self.y0 + tile_size }
      }
    end,
    compass = {
      points = {'n','e','s','w'},
      index = 1,
      facing = function(self)
        return self.points[self.index]
      end,
      rotate = function(self)
        self.index += 1
        self.index = self.index % #self.points
        if self.index == 0 then self.index = #self.points end
      end
    },
    x0 = 0,
    y0 = 0,
    x1 = function(self)
      if self:is_vertical() then
        return calculate_x1(self.x0, self.width)
      else
        return calculate_x1(self.x0, self.height)
      end
    end,
    y1 = function(self)
      if self:is_vertical() then
        return calculate_y1(self.y0,self.height)
      else
        return calculate_y1(self.y0,self.width)
      end
    end,
    is_vertical = function(self)
      return (self.compass:facing() == 'n' or self.compass:facing() == 's')
    end,
    update = function(self)
      self:move()
    end,
    draw = function(self)
      self:draw_fruits()
    end,
    draw_fruits = function(self)
      local fruits
      if self.compass:facing() == 'n' then
        fruits = self.fruits
      elseif self.compass:facing() == 's' then
        fruits = reverse_table(self.fruits)
      elseif self.compass:facing() == 'e' then
        fruits = {five, three, one, six, four, two}
      elseif self.compass:facing() == 'w' then
        fruits = {two, four, six, one, three, five}
      end

      if self:is_vertical() then
        for k,v in pairs(fruits) do
          spr(v.sprite,self:vertical_slots()[k].x,self:vertical_slots()[k].y)
        end
      else
        for k,v in pairs(fruits) do
          spr(v.sprite,self:horizontal_slots()[k].x,self:horizontal_slots()[k].y)
        end
      end
    end,
    move = function(self)
      if btnp(4) then
        self.compass:rotate()
      elseif btnp(1) then
        self.x0 += tile_size
      elseif btnp(0) then
        self.x0 -= tile_size
      elseif btnp(2) then
        self.y0 -= tile_size
      elseif btnp(3) then
        self.y0 += tile_size
      end
    end
  }
end

function _update()
  selected_card:update()
  adjust_selected_card_or_camera_position(selected_card, cam)
  camera(cam.x0,cam.y0)
end

function _draw()
  cls()
  rect(0,0,127,127,5) --border
  rect(selected_card.x0,selected_card.y0,selected_card:x1(),selected_card:y1(),selected_card.col)
  selected_card:draw()
end

function calculate_x1(x0, width)
  return x0 + width - 1
end

function calculate_y1(y0, height)
  return y0 + height - 1
end

function reverse_table(table)
  local result = {}
  local counter = #table
  for value in all(table) do
    add(result,table[counter])
    counter -= 1
  end
  return result
end

function adjust_selected_card_or_camera_position(selected_card,cam)
  if selected_card:x1() > cam:x1() then
    local adjustment = selected_card:x1() - cam:x1()

    if btnp(4) then
      selected_card.x0 -= adjustment
    else
      cam.x0 += adjustment
    end
  elseif selected_card:y1() > cam:y1() then
    local adjustment = selected_card:y1() - cam:y1()

    if btnp(4) then
      selected_card.y0 -= adjustment
    else
      cam.y0 += adjustment
    end
  elseif selected_card.x0 < cam.x0 then
    local adjustment = cam.x0 - selected_card.x0
    
    cam.x0 -= adjustment
  elseif selected_card.y0 < cam.y0 then
    local adjustment = cam.y0 - selected_card.y0
    
    cam.y0 -= adjustment
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000cc0000099900000bbbb0000e000000077770000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000c0000000900000000b0000e0e0000070000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000c0000099000000000b0000e0e0000077700000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000c0000090000000bbbb0000eeee000000700000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000c0000099900000000b000000e0000077700000d00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccccc00000000000bbbb000000e0000000000000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000
