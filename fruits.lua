make_fruit = function(name,sprite)
  local fruit = {
    name = name,
    x = 0,
    y = 0,
    sprite = sprite,
    is_growable = function(self)
      for fruit in all(planted_fruits) do
        if (fruit.x == self.x) 
        and (fruit.y == self.y) 
        and (fruit.name == self.name)
        then return true end
      end

      return false
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

apple = make_fruit('apple',0)
lemon = make_fruit('lemon',2)
berry = make_fruit('berry',4)

planted_fruits = {}