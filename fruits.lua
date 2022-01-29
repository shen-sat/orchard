make_fruit = function(name,color)
  local fruit = {
    name = name,
    x = 0,
    y = 0,
    sprite = function(self)
      local seed_sprite = { sx = 0, sy = 8, sw = 6, sh = 3, dx = (self.x + 6), dy = (self.y + 7), flip_x = false, flip_y = false }
      local bush_sprite = { sx = 0, sy = 0, sw = 10, sh = 8, dx = (self.x + 3), dy = (self.y + 4), flip_x = false, flip_y = false }
      local sapling_sprite = { sx = 9, sy = 0, sw = 12, sh = 12, dx = (self.x + 2), dy = (self.y + 2), flip_x = false, flip_y = true }
      local tree_sprite = { sx = 0, sy = 11, sw = 14, sh = 14, dx = (self.x + 1), dy = (self.y + 1), flip_x = false, flip_y = false }
      local plant_sprites = { seed_sprite,bush_sprite,sapling_sprite,tree_sprite }

      return plant_sprites[self:age_index()]
    end,
    draw = function(self)
      rectfill(self.x,self.y,calculate_x1(self.x,tile_size),calculate_x1(self.y,tile_size),3)

      pal(spritesheet_fruit_color,self.color)

      local sprite = self:sprite()
      sspr(sprite.sx,sprite.sy,sprite.sw,sprite.sh,sprite.dx,sprite.dy,sprite.sw,sprite.sh,sprite.flip_x,sprite.flip_y)
    end,
    color = color,
    age = 0,
    ages = {0,1,3,6},
    age_index = function(self)
      local index
      for i,age in pairs(self.ages) do
        if self.age == age then index = i end
      end

      return index
    end,
    grow = function(self)
      if self:age_index() == #self.ages then return end

      self.age = self.ages[self:age_index() + 1]
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