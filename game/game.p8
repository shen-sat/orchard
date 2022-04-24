pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
  game = {}
  start_game(true)
end

function _update()
  game.update()
end

function _draw()
  game.draw()
end

function start_game(is_first_time)
  #include lib/global_variables.lua
  #include lib/blink.lua
  #include lib/camera.lua
  #include lib/fruits.lua
  #include lib/deck.lua
  #include lib/selected_card.lua
  #include lib/lawn.lua
  #include lib/card_slide_manager.lua
  #include lib/z_button.lua
  #include lib/x_button.lua
  #include lib/pause_screen.lua
  #include lib/notice_board.lua
  #include lib/rank_screen.lua
  #include lib/intro.lua

  
  fade_object = {
    fade_counter = 0,
    fade_step = 0,
    is_finished = false,
    pal_data = {3,5,1,0,0,1,5,3},
    calculate_fade = function(self)
      local num = self.fade_counter % 5
      if num == 0 then self.fade_step += 1 end
      self.fade_counter += 1
      if self.fade_step > #self.pal_data then self.is_finished = true end
    end,
    update = function(self)
      self:calculate_fade()
    end,
    draw = function(self)
      if not self.pal_data[self.fade_step] then return rectfill(0,0,127,127,3) end
      rectfill(0,0,127,127,self.pal_data[self.fade_step]) 
    end
  }

  fade_object_two = {
    fade_counter = 0,
    fade_step = 0,
    is_finished = false,
    pal_data = {3,5,1,0,0,1,5,3},
    calculate_fade = function(self)
      local num = self.fade_counter % 5
      if num == 0 then self.fade_step += 1 end
      self.fade_counter += 1
      if self.fade_step > #self.pal_data then self.is_finished = true end
    end,
    update = function(self)
      self:calculate_fade()
    end,
    draw = function(self)
      if not self.pal_data[self.fade_step] then return rectfill(0,0,127,127,3) end
      rectfill(0,0,127,127,self.pal_data[self.fade_step]) 
    end
  }

  selected_card:place_starting_card()

  if is_first_time then
    game.update = intro_update
    game.draw = intro_draw
    music(0)
  else
    game.update = game_update
    game.draw = game_draw
  end
end

function game_update()
  pause_screen:update()
  if is_notice_board_or_pause_screen_showing() then return end
  z_button:update()
  selected_card:update()
  blink:update()
  for fruit in all(planted_fruits) do
    fruit:update()
  end
  card_slide_manager:update()
  adjust_selected_card_or_camera_position(selected_card,cam,card_slide_manager)
  camera(cam.x0,cam.y0)
end

function game_draw()
  cls(5)

  lawn:draw()

  for fruit in all(planted_fruits) do
    fruit:draw()
  end
  selected_card:draw()
  pause_screen:draw()
  notice_board:draw()
end

function view_orchard()
  game.update = view_orchard_update
  game.draw = view_orchard_draw
  music(0, 7000)
end

function view_orchard_update()
  if btnp(1) then
    cam.x0 += tile_size
    camera(cam.x0,cam.y0)
  elseif btnp(0) then
    cam.x0 -= tile_size
    camera(cam.x0,cam.y0)
  elseif btnp(2) then
    cam.y0 -= tile_size
    camera(cam.x0,cam.y0)
  elseif btnp(3) then
    cam.y0 += tile_size
    camera(cam.x0,cam.y0)
  end
  
  for fruit in all(planted_fruits) do
    fruit:update()
  end
  notice_board:update()
  x_button:update()
  if x_button.is_just_released then
    game.update = show_scores_update
    game.draw = show_scores_draw
    camera(0,0)
    cam.x0 = 0
    cam.y0 = 0
  end
end

function view_orchard_draw()
  cls(5)
  lawn:draw()

  for fruit in all(planted_fruits) do
    fruit:draw()
  end
  notice_board:draw()
end

function show_scores_update()
  if not fade_object.is_finished then return fade_object:update() end

  blink:update()
  x_button:update()
  if x_button.is_just_released then
    music(-1, 4000)
    foobar()
  end
end


function show_scores_draw()
  cls()
  if not fade_object.is_finished then return fade_object:draw() end
  
  rank_screen:draw()
end

function foobar()
  game.update = foobar_update
  game.draw = foobar_draw
end

function foobar_update()
  if not fade_object_two.is_finished then return fade_object_two:update() end  
  start_game(false)
end

function foobar_draw()
  if not fade_object_two.is_finished then return fade_object_two:draw() end  
end

function intro_update()
  intro:update()
end

function intro_draw()
  intro:draw()
end

#include lib/shared_functions.lua

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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b3333b0000000000000000
00000000000000000000000000000000000000b3333b00000000000000000000000000000000000000000000000000000000000bbbbbbbbbbb30000000000000
000000000000000000000000000000000003bbbbbbbbbb30000000000000000000000000000000000000000000000000000000bbbbbbbbbbbb33000000000000
00000000000000000000000000000000003bbbbbbbbbbb3300000000000000000000000000000000000000000000000000000bbbbb77bbbbbb3b300000000000
00000000000000000000000000000000033bbb7bbbbbbb3b3000000000000000000000000000000000000000000000000000bbbb77777bbbbbbbb33000000000
00000000000000000000000000000000333b7777bbbbbbbbb30000000000000000000000000000000000000000000000000bbbb77777bbbbbbbb333300000000
0000000000000000000000000000000bbbb7777bbbbbb33b33300000000000000000000000000000000000000000000000bbbb777bbbbbbbbbbb333300000000
000000000000000000000000000000bbbb7b7bbbbbbbbb333333000000000000000000000000000000000000000000000bbbbb77bbbbbbb3bbb3333330000000
00000000000000000000000000000bbbb777bbbbbbb3b3333333300000000000000000000000000000000000000000000bbbbbbbbbbbbb333333333330000000
00000000000000000000000000000bbbbb7bbbbbbb33333333b330000000000000000000000000000000000000000000033bbbbbbbbbb3333333333330000000
000000000000000000000000000003bbbbbbbbbbb33333333bbb300000000000000000000000000000000000000000003333bb333b3b33333333333333000000
000000000000000000000000000033bbbb333b3b333333333bb3330000000000000000000000000000000000000000003333bbb3333333bbbb3333bb33000000
0000000000000000000000000000333bbbb3333333bbbbb3bbbb3300000000000000000000000000000000000000000033333b33333b3bbbbbb3bbbb33000000
000000000000000000000000000033333b33333b3bbbbbbbbbbb330000000000000000000000000000000000000000003333333333bbbbb7bbbbbbbb33000000
00000000000000000000000000003333333333bbbbb7bbbbbbbb33000000000000000000000000000000000000000000333bb333333bb777bbbbbbbb33000000
000000000000000000000000000033333333333bb7777bbbbbbb33000000000000000000000000000000000000000000333bbb33333b7777bbbbbbb333000000
000000000000000000000000000033333333333b7777bbbbbbb33300000000000000000000000000000000000000000003bbb733b33b777bbbbbbb3330000000
00000000000000000000000000000333b333b33bb7bbbbbbbb3330000000000000000000000000000000000000000000033b777bbb33b7bbbbbbb33330000000
0000000000000000000000000000033bbb7bbb33bbbbbbbbb333300000000000000000000000000000000000000000000333b777bb333bbbbbbbbb3330000000
00000000000000000000000000000333b777bb333bbbbbbbbb33300000000000000000000000000000000000000000000033bbbbb33bbbbbb333b33300000000
00000000000000000000000000000033bb7bbbbb33bbb333b3330000000000000000000000000000000000000000000000033bbb3333bbbb3333333000000000
000000000000000000000000000000033bbbbbbbb33b3333333000000000000000000000000000000000000000000000000033bb33333bb33333330000000000
0000000000000000000000000000000033bbbbb333333333330000000000000000000000000000000000000000000000000003b3333333323333300000000000
0000000000000000000000000000000003bbb333333233333000000000000000000000000000000000000000000000000000003b333333222333000000000000
00000000000000000000000000000000003b33333322233300000000000000000000000000000000000000000000000000000003332332223330000000000000
00000000000000000000000000000000000333233222333000000000000000000000000000000000000000000000000000000000022242230000000000000000
00000000000000000000000000000000000002224223000000000000000000000000000000000000000000000000000000000000002442000000000000000000
00000000000000000000000000000000000000244200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbbb33333bbbbbbbbb33333333bbbb33334442333333bbb33333bbbb33333bbbbbbbbb3333bbbbbbbb000000000000000000000000000000000000000000
00bbbbbbbb333bbbbbbbbbb33333bbbbbbbb334442333333bbb333bbbbbbbb333bbbbbbbbbb333bbbbbbbbbb0000000000000000000000000000000000000000
0bbbbbbbbbb33bbbbbbbbbbb333bbbbbbbbbb34444333333bbb33bbbbbbbbbb33bbbbbbbbbbb33bbbbbbbbbbb000000000000000000000000000000000000000
bbbbbbbbbbbb3bbb33333bbbb3bbbbbbbbbbbb4444333333bbb3bbbbbbbbbbbb3bbb33333bbbb3bbbbbbbbbbbb00000000000000000000000000000000000000
bbbbb33bbbbb3bbb333333bbb3bbbbb333bbbb4442333333bbb3bbbbb33bbbbb3bbb333333bbb3bbb3333bbbbb00000000000000000000000000000000000000
bbbb3333bbbb3bbb333333bbb3bbbb33333bbb4442333333bbb3bbbb3333bbbb3bbb333333bbb3bbb33333bbbb00000000000000000000000000000000000000
bbb333333bbb3bbb33333bbbb3bbb3333333334442333333bbb3bbb333333bbb3bbb33333bbbb3bbb333333bbb00000000000000000000000000000000000000
bbb333333bbb3bbbbbbbbbbb33bbb3333333334442bbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbbbb33bbb333333bbb00000000000000000000000000000000000000
bbb333333bbb3bbbbbbbbbb333bbb3333333334442bbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbbb333bbb333333bbb00000000000000000000000000000000000000
bbb333333bbb3bbbbbbbbb3333bbb3333333334242bbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbb3333bbb333333bbb00000000000000000000000000000000000000
bbb333333bbb3bbbbbb3333333bbb3333333334244333333bbb3bbb333333bbb3bbbbbb3333333bbb333333bbb00000000000000000000000000000000000000
bbb333333bbb3bbbbbbb333333bbb3333333334244333333bbb3bbb333333bbb3bbbbbbb333333bbb333333bbb00000000000000000000000000000000000000
bbb333333bbb3bbbbbbbb33333bbb3333333334244333333bbb3bbb333333bbb3bbbbbbbb33333bbb333333bbb00000000000000000000000000000000000000
bbb333333bbb3bbb3bbbbb3333bbb3333333334244333333bbb3bbb333333bbb3bbb3bbbbb3333bbb333333bbb00000000000000000000000000000000000000
bbbb3333bbbb3bbb33bbbbb3111bbb33333bbb4444aaa333bbb3bbb333333bbb3bbb33bbbbb333bbb33333bb8880000000000000000000000000000000000000
bbbbb33bbbbb3bbb333bbbbb111bbbb333bbbb4444aa9333bbb3bbb333333bbb3bbb333bbbbb33bbb3333bbb8820000000000000000000000000000000000000
bbbbbbbbbbbb3bbb3333bbbb111bbbbbbbbbb24444a99333bbb3bbb333333bbb3bbb3333bbbbb3bbbbbbbbbb8220000000000000000000000000000000000000
0bbbbbbbbbb33bbb33333b1113111bbbbbbb2244aaa3aaa3bbb3bbb333333bbb3bbb33333bbbb3bbbbbbbb888088808880000000000000000000000000000000
00bbbbbbbb333bbb3333331113111bbbbbb22244aa93aa93bbb3bbb333333bbb3bbb333333bbb3bbbbbbbb882088208820000000000000000000000000000000
0000bbbb33333bbb33333311131113bbbb222244a993a993bbb3bbb333333bbb3bbb3333333bb3bbbbbbbb822082208220000000000000000000000000000000
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777b3333b7777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777773bbbbbbbbbb37777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777773bbbbbbbbbbb33777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777733bbb7bbbbbbb3b377777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777333b7777bbbbbbbbb37777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777bbbb7777bbbbbb33b333777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777bbbb7b7bbbbbbbbb33333377777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777bbbb777bbbbbbb3b333333337777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777bbbbb7bbbbbbb33333333b337777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777773bbbbbbbbbbb33333333bbb37777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777733bbbb333b3b333333333bb333777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777333bbbb3333333bbbbb3bbbb33777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777733333b33333b3bbbbbbbbbbb33777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777773333333333bbbbb7bbbbbbbb33777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777733333333333bb7777bbbbbbb33777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777733333333333b7777bbbbbbb333777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777333b333b33bb7bbbbbbbb3337777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777733bbb7bbb33bbbbbbbbb33337777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777333b777bb333bbbbbbbbb3337777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777733bb7bbbbb33bbb333b33377777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777733bbbbbbbb33b3333333777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777733bbbbb333333333337777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777773bbb33333323333377777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777773b333333222333777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777773332332223337777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777722242237777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777772442777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777bbbb33333bbbbbbbbb33333333bbbb33334442333333bbb33333bbbb33333bbbbbbbbb3333bbbbbbbb7777777777777777777777
7777777777777777777777bbbbbbbb333bbbbbbbbbb33333bbbbbbbb334442333333bbb333bbbbbbbb333bbbbbbbbbb333bbbbbbbbbb77777777777777777777
777777777777777777777bbbbbbbbbb33bbbbbbbbbbb333bbbbbbbbbb34444333333bbb33bbbbbbbbbb33bbbbbbbbbbb33bbbbbbbbbbb7777777777777777777
77777777777777777777bbbbbbbbbbbb3bbb33333bbbb3bbbbbbbbbbbb4444333333bbb3bbbbbbbbbbbb3bbb33333bbbb3bbbbbbbbbbbb777777777777777777
77777777777777777777bbbbb33bbbbb3bbb333333bbb3bbbbb333bbbb4442333333bbb3bbbbb33bbbbb3bbb333333bbb3bbb3333bbbbb777777777777777777
77777777777777777777bbbb3333bbbb3bbb333333bbb3bbbb33333bbb4442333333bbb3bbbb3333bbbb3bbb333333bbb3bbb33333bbbb777777777777777777
77777777777777777777bbb333333bbb3bbb33333bbbb3bbb3333333334442333333bbb3bbb333333bbb3bbb33333bbbb3bbb333333bbb777777777777777777
77777777777777777777bbb333333bbb3bbbbbbbbbbb33bbb3333333334442bbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbbbb33bbb333333bbb777777777777777777
77777777777777777777bbb333333bbb3bbbbbbbbbb333bbb3333333334442bbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbbb333bbb333333bbb777777777777777777
77777777777777777777bbb333333bbb3bbbbbbbbb3333bbb3333333334242bbbbbbbbb3bbbbbbbbbbbb3bbbbbbbbb3333bbb333333bbb777777777777777777
77777777777777777777bbb333333bbb3bbbbbb3333333bbb3333333334244333333bbb3bbb333333bbb3bbbbbb3333333bbb333333bbb777777777777777777
77777777777777777777bbb333333bbb3bbbbbbb333333bbb3333333334244333333bbb3bbb333333bbb3bbbbbbb333333bbb333333bbb777777777777777777
77777777777777777777bbb333333bbb3bbbbbbbb33333bbb3333333334244333333bbb3bbb333333bbb3bbbbbbbb33333bbb333333bbb777777777777777777
77777777777777777777bbb333333bbb3bbb3bbbbb3333bbb3333333334244333333bbb3bbb333333bbb3bbb3bbbbb3333bbb333333bbb777777777777777777
77777777777777777777bbbb3333bbbb3bbb33bbbbb3111bbb33333bbb4444aaa333bbb3bbb333333bbb3bbb33bbbbb333bbb33333bb88877777777777777777
77777777777777777777bbbbb33bbbbb3bbb333bbbbb111bbbb333bbbb4444aa9333bbb3bbb333333bbb3bbb333bbbbb33bbb3333bbb88277777777777777777
77777777777777777777bbbbbbbbbbbb3bbb3333bbbb111bbbbbbbbbb24444a99333bbb3bbb333333bbb3bbb3333bbbbb3bbbbbbbbbb82277777777777777777
777777777777777777777bbbbbbbbbb33bbb33333b1113111bbbbbbb2244aaa3aaa3bbb3bbb333333bbb3bbb33333bbbb3bbbbbbbb8887888788877777777777
7777777777777777777777bbbbbbbb333bbb3333331113111bbbbbb22244aa93aa93bbb3bbb333333bbb3bbb333333bbb3bbbbbbbb8827882788277777777777
777777777777777777777777bbbb33333bbb33333311131113bbbb222244a993a993bbb3bbb333333bbb3bbb3333333bb3bbbbbbbb8227822782277777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777222722272227722772277777272777772227722777777227222722272227222777777777777777777777777777777
77777777777777777777777777777777777272727272777277727777777272777777277272777772777727727272727727777777777777777777777777777777
77777777777777777777777777777777777222722772277222722277777727777777277272777772227727722272277727777777777777777777777777777777
77777777777777777777777777777777777277727272777772777277777272777777277272777777727727727272727727777777777777777777777777777777
77777777777777777777777777777777777277727272227227722777777272777777277227777772277727727272727727777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__sfx__
915f0010115351151513535135151153511515155351551511535115151353513515115351151516535165150e505005050050500505005050050500505005051050500505005050050500505005050050500505
000a00000d0100d0000d0010c001000010000100001000010f0000f00000001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001
000300000a7140a72011720137201470016720187201b7201d7201c7001f7201f7202270022720247250a70007700057000370000700007000070000700047000170000700007000070000700007000070000700
000200000a7100a7100c7300f73013730187301b7301b7301873018730187301b7301b7301f7302473029730297302870026700227001f7001a700137000b7000770000700000000000000000000000000000000
000300000a7100f720117200f7200a7101b700167101b730217301b73016710127001d71022730297301f7301b7102770022710277202e720297202271000700057000070018700137000f7000a7000570003700
__music__
03 00424344
