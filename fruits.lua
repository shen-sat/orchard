make_fruit = function(name,color)
  local fruit = {
    name = name,
    x = 0,
    y = 0,
    sprite = 0,
    color = color,
    age = 0,
    ages = {1,3,6},
    grow = function(self)
      local index
      for i,age in pairs(self.ages) do
        if self.age == age then index = i end
      end

      if index == nil then 
        self.age = self.ages[1]
      elseif (index == #self.ages) then
        return
      else
        self.age = self.ages[index + 1]
      end
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