make_fruit = function(name,color)
  local fruit = {
    name = name,
    x = 0,
    y = 0,
    color = color,
    age = 0,
    ages = {0,3,6,9},
    age_index = function(self)
      local index
      for i,age in pairs(self.ages) do
        if self.age == age then index = i end
      end
      return index
    end,
    draw = function(self)
      rectfill(self.x,self.y,calculate_x1(self.x,tile_size),calculate_x1(self.y,tile_size),3)

      pal(spritesheet_fruit_color,self.color)

      spr(self.sprite,self.x,self.y,fruit_sprite_width,fruit_sprite_height)
    end,
    update = function(self)
      self:calculate_sprite()
    end,
    grow_time = -1,
    current_animation_index = 1,
    is_growing = false,
    is_pushing_max_age = false,
    is_animation_frame = function(self)
      return (self.grow_time % 2) == 0
    end,
    calculate_sprite = function(self)
      local age_index = self:age_index()

      if self.is_growing then
        self.grow_time += 1

        if not self:is_animation_frame() then return end

        local animation = self.animations[age_index - 1]

        self.sprite = animation[self.current_animation_index]

        self.current_animation_index += 1

        if self.current_animation_index > #animation then
          self:reset_and_stop_animation()
        end
      else
        local sprites = {0,2,4,6}

        self.sprite = sprites[age_index]
      end
    end,
    reset_and_stop_animation = function(self)
      self.is_growing = false
      self.current_animation_index = 1
      self.grow_time = -1
    end,
    sprite,
    animations = {
      {32,34,36,38,40,42,44},
      {64,66,68,70,72,74,76},
      {96,98,100,102,104,106,108}
    },
    grow = function(self)
      local age_index = self:age_index()

      if age_index >= #self.ages then
        self.is_pushing_max_age = true
        return 
      end

      self.age = self.ages[age_index + 1]

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