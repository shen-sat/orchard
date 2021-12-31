selected_card = {
  width = 2 * tile_size,
  height = 3 * tile_size,
  x0 = first_card_place_x,
  y0 = first_card_place_y,
  col = 7,
  dealt_x0 = function()
    return (cam.x0 + 128 - 32)
  end,
  dealt_y0 = cam.y0,
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
    if btnp(5) and self:is_plantable() then
      for fruit in all(self.card) do
        if fruit.is_growable then score += 1 end
        add(planted_fruits,fruit)
      end
      local next_card = copy_table(deck.cards[1])
      self.card = next_card
      del(deck.cards,deck.cards[1])
      self.compass.index = 1
      self.x0 = self:dealt_x0()
      self.y0 = self.dealt_y0
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
    self.x0 = self:dealt_x0()
    self.y0 = self.dealt_y0
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
    -- mark plantable
    for fruit in all(fruits) do fruit.is_growable = false end
    local overlapping_fruits = {}

    if self:is_plantable() then
      for fruit in all(fruits) do
        for f in all(planted_fruits) do
          if (fruit.x == f.x) 
          and (fruit.y == f.y) 
          and (fruit.name == f.name) 
          then add(overlapping_fruits,fruit) end
        end
      end
    end

    for fruit in all(overlapping_fruits) do
      fruit.is_growable = true
    end
  end,
  is_plantable = function(self)
    local fruits = self.card

    local plantable = true
    for fruit in all(fruits) do
      for f in all(planted_fruits) do
        if (fruit.x == f.x) 
        and (fruit.y == f.y) 
        and not (fruit.name == f.name) 
        then plantable = false end
      end
    end

    return plantable
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
      if fruit.is_growable and blink:blink() then 
        palt(0,false)
        pal(0,11)
      end
      spr(fruit.sprite,fruit.x,fruit.y,fruit_sprite_width,fruit_sprite_height)
      pal()
      palt()
    end
  end,
  draw_border = function(self)
    rect(self.x0,self.y0,self:x1(),self:y1(),self.col)
  end
}
