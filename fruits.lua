make_fruit = function(name,sprite)
  local fruit = {
    name = name,
    x = 0,
    y = 0,
    sprite = sprite,
    is_growable = false  
  }

  return fruit
end

apple = make_fruit('apple',0)
lemon = make_fruit('lemon',2)
berry = make_fruit('berry',4)

planted_fruits = {}