make_fruit = function(name,color)
  local fruit = {
    name = name,
    x = 0,
    y = 0,
    color = color,
    age = 0,
    ages = {0,1,3,6},
    draw = function(self)
      rectfill(self.x,self.y,calculate_x1(self.x,tile_size),calculate_x1(self.y,tile_size),3)

      pal(spritesheet_fruit_color,self.color)

      spr(self.sprite,self.x,self.y,fruit_sprite_width,fruit_sprite_height)
    end,
    update = function(self)
      self:calculate_sprite()
    end,
    grow_time = 0,
    calculate_sprite = function(self)
      if self.is_growing then
        if not ((self.grow_time % 2) == 0) then 
          self.grow_time += 1
          return
        end

        self.grow_time += 1

        local index
        for i,age in pairs(self.ages) do
          if self.age == age then index = i end
        end

        local animation = self.animations[index - 1]

        local frame = animation[self.current_animation_index]

        self.current_animation_index += 1

        if self.current_animation_index > #animation then
          self.is_growing = false
          self.current_animation_index = 1
          self.grow_time = 0
        end

        self.sprite = frame
      else
        local sprites = {0,2,4,6}

        local index
        for i,age in pairs(self.ages) do
          if self.age == age then index = i end
        end

        self.sprite = sprites[index]
      end
    end,
    sprite,
    animations = {
      {32,34,36,38,40,42,44},
      {64,66,68,70,72,74,76},
      {96,98,100,102,104,106,108}
    },
    current_animation_index = 1,
    is_growing = false,
    grow = function(self)
      local index
      for i,age in pairs(self.ages) do
        if self.age == age then index = i end
      end

      if index == #self.ages then return end

      self.age = self.ages[index + 1]

      self.is_growing = true
    end,
    matching_fruit = function(self)
      for fruit in all(planted_fruits) do
        if (fruit.x == self.x) 
        and (fruit.y == self.y) 
        and (fruit.name == self.name)
        then return fruit end
      end

      return nil
    end,
    is_plantable = function(self)
      for fruit in all(planted_fruits) do
        if (fruit.x == self.x) 
        and (fruit.y == self.y) 
        and not (fruit.name == self.name)
        then return false end
      end

      return true
    end
  }

  return fruit
end

apple = make_fruit('apple',8)
lemon = make_fruit('lemon',10)
berry = make_fruit('berry',1)

planted_fruits = {}