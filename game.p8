pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
  game = {}
  start_game()
end

function _update()
  game.update()
end

function _draw()
  game.draw()
end

function start_game()
  game.update = game_update
  game.draw = game_draw
  tile_size = 16
  fruit_sprite_width = 2
  fruit_sprite_height = 2
  card_number = 1

  score = 0

  blink = {
    blink = function(self)
      return self.time < 9
    end,
    time = 0,
    update = function(self)
      self.time = (self.time + 1) % 18
    end
  }

  cam = {
    x0 = 0,
    y0 = 0,
    width = 128,
    height = 128,
    x1 = function(self)
      return calculate_x1(self.x0, self.width)
    end,
    y1 = function(self)
      return calculate_y1(self.y0, self.height)
    end
  }

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

  apple = {
    name = 'apple',
    x = 0,
    y = 0,
    sprite = 0,
    is_growable = false
  }
  lemon = {
    name = 'lemon',
    x = 0,
    y = 0,
    sprite = 2,
    is_growable = false
  }
  berry = {
    name = 'berry',
    x = 0,
    y = 0,
    sprite = 4,
    is_growable = false
  }

  card_one = { copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry) }
  card_two = { copy_table(lemon), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry) }
  card_three = { copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry) }
  card_four = { copy_table(berry), copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple) }
  card_five = { copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple), copy_table(berry) }
  card_six = { copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry) }
  card_seven = { copy_table(lemon), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry) }
  card_eight = { copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry) }
  card_nine = { copy_table(apple), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(lemon), copy_table(apple) }

  deck = { card_two, card_three, card_four, card_five, card_six, card_seven, card_eight, card_nine }

  deck_start_count = #deck

  planted_fruits = {}

  selected_card = {
    width = 2 * tile_size,
    height = 3 * tile_size,
    col = 7,
    card = card_one,
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
    x0 = cam.x0 + 128 - 32,
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
      self:plant_fruits()
      self:move()
      self:update_fruits()
    end,
    draw = function(self)
      self:draw_fruits()
      self:draw_border()
    end,
    plant_fruits = function(self)
      if btnp(5) and self:is_plantable() then
        for fruit in all(self.card) do
          if fruit.is_growable then score += 1 end
          add(planted_fruits,fruit)
        end
        card_number += 1
        local next_card = copy_table(deck[1])
        self.card = next_card
        del(deck,deck[1])
        self.compass.index = 1
        self.x0 = cam.x0 + 128 - 32
        self.y0 = cam.y0
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
    update_fruits = function(self)
      local fruits
      if self.compass:facing() == 'n' then
        fruits = self.card
      elseif self.compass:facing() == 's' then
        fruits = reverse_table(self.card)
      elseif self.compass:facing() == 'e' then
        fruits = self:order_fruits_east()
      elseif self.compass:facing() == 'w' then
        fruits = self:order_fruits_west()
      end

      if self:is_vertical() then
        for i,fruit in pairs(fruits) do
          fruit.x = self:vertical_slots()[i].x
          fruit.y = self:vertical_slots()[i].y
        end
      else
        for i,fruit in pairs(fruits) do
          fruit.x = self:horizontal_slots()[i].x
          fruit.y = self:horizontal_slots()[i].y
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
    draw_border = function(self)
      rect(self.x0,self.y0,self:x1(),self:y1(),self.col)
    end,
    draw_fruits = function(self)
      for fruit in all(self.card) do
        if fruit.is_growable then 
          if blink:blink() then
            palt(0,false)
            pal(0,11)
          end
        end
        spr(fruit.sprite,fruit.x,fruit.y,fruit_sprite_width,fruit_sprite_height)
        pal()
        palt()
      end
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
    order_fruits_east = function(self)
      return { self.card[5], self.card[3], self.card[1], self.card[6], self.card[4], self.card[2] }
    end,
    order_fruits_west = function(self)
      return { self.card[2], self.card[4], self.card[6], self.card[1], self.card[3], self.card[5] }
    end,
  }
end

function game_update() 
  selected_card:update()
  adjust_selected_card_or_camera_position(selected_card, cam)
  camera(cam.x0,cam.y0)
  blink:update()
  if card_number > deck_start_count + 1 then game_over() end
end

function game_draw()
  cls(5)
  for fruit in all(planted_fruits) do
    spr(fruit.sprite,fruit.x,fruit.y,fruit_sprite_width,fruit_sprite_height)
  end
  selected_card:draw()
  print('card:'..card_number..' of '..deck_start_count + 1,cam.x0 + 1,cam.y0 + 1,7)
  print('score:'..score,cam.x0 + 1,cam.y0 + 7,7)
end

function game_over()
  game.update = game_over_update
  game.draw = game_over_draw
end

function game_over_update()
  if btnp(5) then start_game() end
end

function game_over_draw()
  cls()
  print('game over',cam.x0 + 1,cam.y0 + 1,7)
  print('final score:'..score,cam.x0 + 1,cam.y0 + 7,7)
  print('press x to replay',cam.x0 + 1,cam.y0 + 13,7)
end

function calculate_x1(x0, width)
  return x0 + width - 1
end

function calculate_y1(y0, height)
  return y0 + height - 1
end

function reverse_table(table)
  local result = {}
  local counter = #table
  for value in all(table) do
    add(result,table[counter])
    counter -= 1
  end
  return result
end

function adjust_selected_card_or_camera_position(selected_card,cam)
  if selected_card:x1() > cam:x1() then
    local adjustment = selected_card:x1() - cam:x1()

    if btnp(4) then
      selected_card.x0 -= adjustment
    else
      cam.x0 += adjustment
    end
  elseif selected_card:y1() > cam:y1() then
    local adjustment = selected_card:y1() - cam:y1()

    if btnp(4) then
      selected_card.y0 -= adjustment
    else
      cam.y0 += adjustment
    end
  elseif selected_card.x0 < cam.x0 then
    local adjustment = cam.x0 - selected_card.x0
    
    cam.x0 -= adjustment
  elseif selected_card.y0 < cam.y0 then
    local adjustment = cam.y0 - selected_card.y0
    
    cam.y0 -= adjustment
  end
end

function copy_table(table)
  new_table = {}
  for k,v in pairs(table) do
    new_table[k] = v
  end

  return new_table
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
008888888888880000aaaaaaaaaaaa00001111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
