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
00011110001442442241000011110000000bbee000000000000cc00000000000000000000000ee0eee0000eeeeeeeee000000000000000000003000000000000
001bbbb10001333333100001bb111000000bbbe00000000000cccc00000000000000000000eeee0eee0000eeeeeeeeee00000000000003330033303000000000
01b78bbb1013333333310001bb13300000eeeee30000000000bbcc0000000000000000000eeeee0eee0000eeeeeeeeeee0000000000033333333333300000000
1bb88bb33133b3bb333311111111111000eeee330000000000bbcc000000000000000000eeeeee0eee0000eee00000eeee00000000033333bb33bb3000000000
1bbbbbbb313bbbb3bb33100eeeeee000eeeeeeeeee0000000cccccc00000000000000000eeeee00eee0000eee000000eee000000303b3bbbbbbbbb3300000000
1bbbb3b331bbbbbbbbb310eeeeeeee0eeeeeeeeeeee000000cccc3300000000000000000eeee000eee0000eee000000eee000003333bbb7bbbbbbb3b30300000
11bbbb3311bbbbbbbb331eeeeeeeeee0000cccccc00000000cccccc00000000000000000eee0000eee0000eee00000eeee000003333b7777bbbbbbbbb3330000
01133331101bb88bbbb10eeeeeeeeee00cccccccccc00000cccccccc0000000000000000eeeeee0eeeeee0eeeeeeeeeee000030b3bb7777bbbbbb33b33330030
078000000001b78bbb10eeeeeeeeeeeecccccccccccc000cccccccccc000000000000000eeeeee0eeeeee0eeeeeeeeee0003333bbb7b7bbbbbbbbb3333333333
0880000000001bbbb100000000eeee0000cccccccccc00cccccccccccc00000000000000eeeeee0eeeeee0eeeeeeeee0003333bbb777bbbbbbb3b33333333330
11110100000001bb100000000eeeeee0cccccccccccccc00000bbcc00000000000000000eee0000eee0000eeeeee000000033bbbbb7bbbbbbb33333333b33330
0000011110000011000000000eeeeee00000cccc00000000000bbcc00000000000000000eee0000eee0000eeeeeee000000333bbbbbbbbbbb33333333bbb3330
00011bbbb110000011111100eeeeeeee000cccccc0000000000bbcc00000000000000000eee0000eee0000eeeeeeee00000033bbbb333b3b333333333bb33300
001bbbbbbbb1000111111110eeeeeeee00cccccccc00000000cbbc330000000000000000eee0000eee0000eee0eeeee00003333bbbb3333333bbbbb3bbbb3300
01bb78bbbbbb10011111111eeeeeeeeee0cccccccc00000000cccc330000000000000000eee0000eee0000eee00eeeee003333333b33333b3bbbbbbbbbbb3300
1bbb88bbbbbbb1011111111eeeeeeeeee0cccccccc0000000cccccccc000000000000000eee0000eee0000eee000eeeee0033333333333bbbbb7bbbbbbbb3300
1bbbbbbbb3bb3111111111110000000000cccccccc000000cccccccccc00000000000000eee0000eee0000eee0000eeeee0333333333333bb7777bbbbbbb3300
1bbbbbbb33b33101111000eeee00000000cccccccc0000cccccccccccccc000000000000eee0000eee0000eee00000eeee3333333333333b7777bbbbbbb33300
1b3bbbbbbbbb3111111100eeee0000000cccccccccccccc0000000000000000000000000eee0000eee0000eee000000eee033333b333b33bb7bbbbbbbb333300
133bbbbb3bb33111111100eeee0000000cccccccccccccc0000000000000000000000000eee0000eee0000eee0000000ee33333bbb7bbb33bbbbbbbbb3333300
0133bbb33333101111110eeeeee0000000000000000cccc000000000000000000000000000000000000000000000000000030333b777bb333bbbbbbbbb333330
001333333331001111110eeeeee0000000000000000cccc000000000000000000000000000000000000000000000000000000033bb7bbbbb33bbb333b3333300
000133333310001111110eeeeee000000000000000cccccc000000000000000000000eeeeeeee000000000eeee000000000ee3333bbbbbbbb33b333333333330
000242222420001111110eeeeee000000000000000cccccc000000000000000000000eeeeeeeeee00000eeeeeeee00000eeee33333bbbbb33333333333330300
01224242442210111111eeeeeeee00000000000000cccccc000000000000000000000eeeeeeeeeee000eeeeeeeeee000eeeee03003bbb3333332333333330000
00011110000000111111eeeeeeee000beee0000000cccccc000000000000000000000eeeeeeeeeeee0eeeeeeeeeeee0eeeeee000333b33333322233333300000
00111111000000111111eeeeeeee000bbee000000cccccccc00000000000000000000eee0000eeeee0eeeee000eeee0eeeee0000033333233222333330000000
11111111110000111100eeeeeeee00eeeeee00000cccccccc00000000000000000000eee00000eeee0eeee00000eee0eeee00000033332224223300333000000
00111111110001b11110eeeeeeee00eeeeee00000cccccccc00000000000000000000eee000000eee0eee0000000000eee000000003333244200000030000000
111111111111011111100000000000eeeee300000cccccccc00000000000000000000eee000000eee0eee0000000000eee000000000000444200000000000000
00000000000001111130000000000eeeeeeee0000cccccccc00000000000000000000eee000000eee0eee0000000000eee000000000000444200000000000000
0000000000001111111100000000eeeeeeeeee000cccccccc00000000000000000000eee000000eee0eee0000000000eee000000000000444400000000000000
