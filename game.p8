pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
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
    width = 2 * 8,
    height = 3 * 8,
    col = 7,
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
      self:adjust_position()
    end,
    move = function(self)
      if btnp(4) then
        self.compass:rotate()
      elseif btnp(1) then
        self.x0 += 8
      elseif btnp(0) then
        self.x0 -= 8
      elseif btnp(2) then
        self.y0 -= 8
      elseif btnp(3) then
        self.y0 += 8
      end
    end,
    adjust_position = function(self)
      if self:x1() > orchard:x1() then
        local adjustment = self:x1() - orchard:x1()

        self.x0 -= adjustment
      elseif self:y1() > orchard:y1() then
        local adjustment = self:y1() - orchard:y1()

        self.y0 -= adjustment
      elseif self.x0 < orchard.x0 then
        local adjustment = orchard.x0 - self.x0

        self.x0 += adjustment
      elseif self.y0 < orchard.y0 then
        local adjustment = orchard.y0 - self.y0

        self.y0 += adjustment
      end
    end
  }
end

function _update()
  selected_card:update()
end

function _draw()
  cls()
  rect(0,0,127,127,5) --border
  rect(selected_card.x0,selected_card.y0,selected_card:x1(),selected_card:y1(),selected_card.col)
end

function calculate_x1(x0, width)
  return x0 + width - 1
end

function calculate_y1(y0, height)
  return y0 + height - 1
end

