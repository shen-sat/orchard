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

  #include global_variables.lua
  #include blink.lua
  #include camera.lua
  #include fruits.lua
  #include deck.lua
  #include selected_card.lua
  #include lawn.lua

  selected_card:place_starting_card()
end

function game_update() 
  selected_card:update()
  adjust_selected_card_or_camera_position(selected_card,cam)
  camera(cam.x0,cam.y0)
  blink:update()
end

function game_draw()
  cls(5)
  
  lawn:draw()

  for fruit in all(planted_fruits) do fruit:draw() end
  selected_card:draw()
  -- print('card:'..selected_card.card_number..'/'..deck.count_after_first_card_placement,cam.x0 + 1,cam.y0 + 1,7)
  -- print('score:'..score,cam.x0 + 1,cam.y0 + 7,7)
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

#include shared_functions.lua

__gfx__
00011110001442442241000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001bbbb1000133333310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01b78bbb101333333331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bb88bb33133b3bb3333100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bbbbbbb313bbbb3bb33100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bbbb3b331bbbbbbbbb3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11bbbb3311bbbbbbbb33100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01133331101bb88bbbb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
078000000001b78bbb10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0880000000001bbbb100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11110100000001bb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111100000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011bbbb11000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001bbbbbbbb100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01bb78bbbbbb10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bbb88bbbbbbb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bbbbbbbb3bb31000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bbbbbbb33b331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b3bbbbbbbbb31000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
133bbbbb3bb331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0133bbb3333310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00133333333100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00013333331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00024222242000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01224242442210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
