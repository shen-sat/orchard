make_fruit = function(name,color)
  local fruit = {
    name = name,
    x = 0,
    y = 0,
    sx = function(self)
      if self.age == 0 or self.age == 1 or self.age == 6 then return 0 end
      return 9
    end,
    sy = function(self)
      if self.age == 0 then return 8 end
      if self.age == 1 or self.age == 3 then return 0 end
      if self.age == 6 then return 11 end
    end,
    sw = function(self)
      if self.age == 0 then return 6 end
      if self.age == 1 then return 10 end
      if self.age == 3 then return 12 end
      if self.age == 6 then return 14 end
    end,
    sh = function(self)
      if self.age == 0 then return 3 end
      if self.age == 1 then return 8 end
      if self.age == 3 then return 12 end
      if self.age == 6 then return 14 end
    end,
    dx = function(self)
      if self.age == 0 then return (self.x + 6) end
      if self.age == 1 then return (self.x + 3) end
      if self.age == 3 then return (self.x + 2) end
      if self.age == 6 then return (self.x + 1) end
    end,
    dy = function(self)
      if self.age == 0 then return (self.y + 7) end
      if self.age == 1 then return (self.y + 4) end
      if self.age == 3 then return (self.y + 2) end
      if self.age == 6 then return (self.y + 1) end
    end,
    flip_x = function(self)
      return false
    end,
    flip_y = function(self)
      if self.age == 3 then return true end

      return false
    end,
    color = color,
    age = 0,
    ages = {0,1,3,6},
    sprite = function(self)
      sprites = {0,2,4,6}

      local index
      for i,age in pairs(self.ages) do
        if self.age == age then index = i end
      end

      return sprites[index]
    end,
    grow = function(self)
      local index
      for i,age in pairs(self.ages) do
        if self.age == age then index = i end
      end

      if index == #self.ages then return end


      self.age = self.ages[index + 1]
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