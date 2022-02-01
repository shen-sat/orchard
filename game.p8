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

  for fruit in all(planted_fruits) do
    fruit:draw()
  end
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
00000000000000000000000000000000000000000000000000000000000000000088800000000000001110000000000000aaa000000000000000000000000000
00000000000000000000000000000000000000000000000000000011110000000088200000000000001110000000000000aa9000000000000000000000000000
000000000000000000000000000000000000000110000000000011bbbb1100000082200000000000001110000000000000a99000000000000000000000000000
000000000000000000000000000000000000001bb10000000001bbbbbbbb100088808880888000001110111000000000aaa0aaa0000000000000000000000000
00000000000000000000001111000000000001bbbb100000001bb78bbbbbb10088208820882000001110111000000000aa90aa90000000000000000000000000
0000000000000000000001bbbb10000000001b78bbb1000001bbb88bbbbbbb1082208220822000001110111000000000a990a990000000000000000000000000
000000000000000000001b78bbb100000001bb88bbbb100001bbbbbbbb3bb3100000000000000000000000000000000000000000000000000000000000000000
00000007800000000001bb88bb331000001bbbbbbbb3310001bbbbbbb33b33100000000000000000000000000000000000000000000000000000000000000000
00000008800000000001bbbbbbb31000001bbbbbbbbb310001b3bbbbbbbbb3100000000000000000000000000000000000000000000000000000000000000000
00000011110100000001bbbb3b3310000013bbbb3bb331000133bbbbb3bb33100000000000000000000000000000000000000000000000000000000000000000
000000000000000000011bbbb331100000133b3bb333310000133bbb333331000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000113333110000000133333333100000013333333310000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000013333331000000001333333100000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000144244224100000002422224200000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000122424244221000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000011110000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000111111000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000001111110000000000000000000000000000000000000000000bbbb0000000000000000000000
00000000000000000000000000000000000000000000000000000111111000000000000000000000000000000000000000000bbbbbb000000000000000000000
0000000000000000000000000000000000000000000000000000011111100000000000000000000000000000000000000000bbbbbbbb00000000000000000000
000000000000000000000000000000000000011111100000000001111110000000000011110000000000000000000000000bbbbbbbbbb0000000000000000000
0000000000000000000000000000000000001111111100000000011111100000000001b1111000000000001111000000000bbbbbbbbbb0000000000000000000
00000011110000000000000000000000000011111111000000000111111000000000011111100000000001bb11100000000bbbbbbbbbb0000000000000000000
00000111111000000000111111110000000011111111000000000111111000000000011111300000000001bb13300000000bbbbbbbbbb0000000000000000000
0001111111111000001111111111110000011111111110000000011111100000000011111111000000011111111110000000bbbbbbbb00000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000001111000000000000000000000000000000000000000000000bb00000000000000000000000
000000000000000000000000000000000000000000000000000000111100000000000000000000000000000000000000000000bbbb0000000000000000000000
00000000000000000000000000000000000000000000000000000011110000000000000000000000000000000000000000000bbbbbb000000000000000000000
0000000000000000000000000000000000000000000000000000011111100000000000000000000000000000000000000000bbbbbbbb00000000000000000000
000000000000000000000000000000000000000000000000000001111110000000000000000000000000000000000000000bbbbbbbbbb0000000000000000000
0000000000000000000000000000000000000011110000000000011111100000000000b111000000000000000000000000bbbbbbbbbbbb000000000000000000
0000000000000000000000000000000000000111111000000000011111100000000000bb11000000000000bb1100000000bbbbbbbbbbbb000000000000000000
00000000000000000000000000000000000001111110000000001111111100000000011111100000000000bbb100000000bbbbbbbbbbbb000000000000000000
00000000000000000000000000000000000011111111000000001111111100000000011111100000000001111130000000bbbbbbbbbbbb000000000000000000
000001111110000000000000000000000000111111110000000011111111000000000111113000000000011113300000000bbbbbbbbbb0000000000000000000
0000111111110000000111111111100000011111111110000000111111110000000011111111000000011111111110000000bbbbbbbb00000000000000000000
000111111111100000111111111111000001111111111000000011111111000000011111111110000011111111111100000bbbbbbbbbb0000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000111100000000000000000000000000000000000000000000bbbb0000000000000000000000
0000000000000000000000000000000000000000000000000000001111000000000000000000000000000000000000000000bbbbbbbb00000000000000000000
000000000000000000000000000000000000000000000000000000111100000000000000000000000000000000000000000bbbbbbbbbb0000000000000000000
00000000000000000000000000000000000000000000000000000011110000000000000000000000000000000000000000bbbbbbbbbbbb000000000000000000
0000000000000000000000000000000000000000000000000000011111100000000000011000000000000000000000000bbbbbbbbbbbbbb00000000000000000
0000000000000000000000000000000000000011110000000000011111100000000000111100000000000000000000000bbbbbbbbbbbbbb00000000000000000
0000000000000000000000000000000000000111111000000000011111100000000000bb11000000000000bb110000000bbbbbbbbbbbbbb00000000000000000
0000000000000000000000000000000000001111111100000000011111100000000000bb11000000000000bb110000000bbbbbbbbbbbbbb00000000000000000
00000000000000000000000000000000000011111111000000001111111100000000011111100000000000bb110000000bbbbbbbbbbbbbb00000000000000000
00000000000000000000000000000000000011111111000000001111111100000000011113300000000001bb1330000000bbbbbbbbbbbb000000000000000000
000000000000000000000000000000000000111111110000000011111111000000000111111000000000011113300000000bbbbbbbbbb0000000000000000000
0000011111100000000000000000000000001111111100000000111111110000000011111111000000001111111100000000bbbbbbbb00000000000000000000
0001111111111000000111111111100000011111111110000000111111110000000111111111100000011111111110000000bbbbbbbb00000000000000000000
00111111111111000111111111111110000111111111100000001111111100000011111111111100011111111111111000bbbbbbbbbbbb000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbbb33333bbbbbbbbb33333333bbbb33333bbb333333bbb33333bbbb33333bbbbbbbbb3333bbbbbbbb000000000000000000000333003330300000000000
00bbbbbbbb333bbbbbbbbbb33333bbbbbbbb333bbb333333bbb333bbbbbbbb333bbbbbbbbbb333bbbbbbbbbb0000000000000000003333333333330000000000
0bbbbbbbbbb33bbbbbbbbbbb333bbbbbbbbbb33bbb333333bbb33bbbbbbbbbb33bbbbbbbbbbb33bbbbbbbbbbb000000000000000033333bb33bb300000000000
bbbbbbbbbbbb3bbb33333bbbb3bbbbbbbbbbbb3bbb333333bbb3bbbbbbbbbbbb3bbb33333bbbb3bbbbbbbbbbbb000000000000303b3bbbbbbbbb330000000000
bbbbb33bbbbb3bbb333333bbb3bbbbb333bbbb3bbb333333bbb3bbbbb33bbbbb3bbb333333bbb3bbb3333bbbbb000000000003333bbb7bbbbbbb3b3030000000
bbbb3333bbbb3bbb333333bbb3bbbb33333bbb3bbb333333bbb3bbbb3333bbbb3bbb333333bbb3bbb33333bbbb000000000003333b7777bbbbbbbbb333000000
bbb333333bbb3bbb33333bbbb3bbb3333333333bbb333333bbb3bbb333333bbb3bbb33333bbbb3bbb333333bbb00000000030b3bb7777bbbbbb33b3333003000
bbb333333bbb3bbbbbbbbbbb33bbb3333333333bbbbbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbbbb33bbb333333bbb00000003333bbb7b7bbbbbbbbb333333333300
bbb333333bbb3bbbbbbbbbb333bbb3333333333bbbbbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbbb333bbb333333bbb0000003333bbb777bbbbbbb3b3333333333000
bbb333333bbb3bbbbbbbbb3333bbb3333333333bbbbbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbb3333bbb333333bbb000000033bbbbb7bbbbbbb33333333b3333000
bbb333333bbb3bbbbbb3333333bbb3333333333bbb333333bbb3bbb333333bbb3bbbbbb3333333bbb333333bbb0000000333bbbbbbbbbbb33333333bbb333000
bbb333333bbb3bbbbbbb333333bbb3333333333bbb333333bbb3bbb333333bbb3bbbbbbb333333bbb333333bbb0000000033bbbb333b3b333333333bb3330000
bbb333333bbb3bbbbbbbb33333bbb3333333333bbb333333bbb3bbb333333bbb3bbbbbbbb33333bbb333333bbb00000003333bbbb3333333bbbbb3bbbb330000
bbb333333bbb3bbb3bbbbb3333bbb3333333333bbb333333bbb3bbb333333bbb3bbb3bbbbb3333bbb333333bbb0000003333333b33333b3bbbbbbbbbbb330000
bbbb3333bbbb3bbb33bbbbb333bbbb33333bbb3bbb333333bbb3bbb333333bbb3bbb33bbbbb333bbb33333bbbb000000033333333333bbbbb7bbbbbbbb330000
bbbbb33bbbbb3bbb333bbbbb33bbbbb333bbbb3bbb333333bbb3bbb333333bbb3bbb333bbbbb33bbb3333bbbbb0000000333333333333bb7777bbbbbbb330000
bbbbbbbbbbbb3bbb3333bbbbb3bbbbbbbbbbbb3bbb333333bbb3bbb333333bbb3bbb3333bbbbb3bbbbbbbbbbbb0000003333333333333b7777bbbbbbb3330000
0bbbbbbbbbb33bbb33333bbbb33bbbbbbbbbb33bbb333333bbb3bbb333333bbb3bbb33333bbbb3bbbbbbbbbbb0000000033333b333b33bb7bbbbbbbb33330000
00bbbbbbbb333bbb333333bbb333bbbbbbbb333bbb333333bbb3bbb333333bbb3bbb333333bbb3bbbbbbbbbb0000000033333bbb7bbb33bbbbbbbbb333330000
0000bbbb33333bbb3333333bb33333bbbb33333bbb333333bbb3bbb333333bbb3bbb3333333bb3bbbbbbbb0000000000030333b777bb333bbbbbbbbb33333000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033bb7bbbbb33bbb333b333330000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333bbbbbbbb33b33333333333000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033333bbbbb3333333333333030000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003003bbb333333233333333000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000333b3333332223333330000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333323322233333000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333222422330033300000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000333324420000003000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042420000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000244440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002244440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022244440000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222244440000000000000000
