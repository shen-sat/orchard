selected_card = {
  width = 2 * tile_size,
  height = 3 * tile_size,
  x0 = first_card_place_x,
  y0 = first_card_place_y,
  col = 7,
  card_number = 1,
  deal_x0 = function()
    return (cam.x0 + 128 - 32)
  end,
  deal_y0 = function()
    return cam.y0
  end,
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
    self:plant_fruits()
    self:move()
    self:update_fruits()
  end,
  plant_fruits = function(self)
    if btnp(5) and self:is_placable() then
      for fruit in all(self.card) do
        
        local matching_planted_fruit = fruit:matching_fruit()
        if matching_planted_fruit then 
          score += 1
          matching_planted_fruit:grow()
        elseif fruit:is_plantable() then
          add(planted_fruits,fruit)
        end        
      end

      if deck:count() < 1 then return game_over() end -- game over

      local next_card = copy_table(deck.cards[1])
      self.card = next_card
      self.card_number += 1
      del(deck.cards,deck.cards[1])
      self.compass.index = 1
      self.x0 = self:deal_x0()
      self.y0 = self:deal_y0()
    end
  end,
  place_starting_card = function(self)
    self.card = copy_table(deck.cards[1])
    del(deck.cards,deck.cards[1])

    self:update_fruits()

    for fruit in all(self.card) do
      add(planted_fruits,fruit)
    end

    local next_card = copy_table(deck.cards[1])
    self.card = next_card
    del(deck.cards,deck.cards[1])
    self.compass.index = 1
    self.x0 = self:deal_x0()
    self.y0 = self:deal_y0()
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
  end,
  update_fruits = function(self)
    local fruits
    if self.compass:facing() == 'n' then
      fruits = self.card
    elseif self.compass:facing() == 's' then
      fruits = reverse_table(self.card)
    elseif self.compass:facing() == 'e' then
      fruits = self:order_fruits_east()
    elseif self.compass:facing() == 'w' then
      fruits = reverse_table(self:order_fruits_east())
    end
    -- update x,y coordinates
    if self:is_vertical() then
      for i,fruit in pairs(fruits) do
        fruit.x, fruit.y = self:vertical_slots()[i].x, self:vertical_slots()[i].y
      end
    else
      for i,fruit in pairs(fruits) do
        fruit.x, fruit.y = self:horizontal_slots()[i].x, self:horizontal_slots()[i].y
      end
    end
  end,
  is_placable = function(self)
    local fruits = self.card
    local number_of_growable_fruits = 0

    for fruit in all(fruits) do
      if not fruit:is_plantable() then return false end

      if fruit:matching_fruit() then number_of_growable_fruits += 1 end
    end

    return number_of_growable_fruits > 0
  end,
  order_fruits_east = function(self)
    return { self.card[5], self.card[3], self.card[1], self.card[6], self.card[4], self.card[2] }
  end,
  draw = function(self)
    self:draw_fruits()
    self:draw_border()
  end,
  draw_fruits = function(self)
    for fruit in all(self.card) do
      if self:is_placable() and fruit:matching_fruit() and blink:blink() then 
        -- palt(0,false)
        pal(3,11)
      end
      pal(spritesheet_fruit_color,fruit.color)
      sspr(fruit:sx(),fruit:sy(),fruit:sw(),fruit:sh(),fruit:dx(),fruit:dy(),fruit:sw(),fruit:sh(),fruit:flip_x(),fruit:flip_y())
      pal()
      palt()
    end
  end,
  draw_border = function(self)
    rect(self.x0,self.y0,self:x1(),self:y1(),self.col)
  end
}
