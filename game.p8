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
  #include card_slide_manager.lua
  #include z_button.lua
  #include x_button.lua
  #include pause_screen.lua
  #include notice_board.lua
  #include rank_screen.lua

  intro = {
    logo = { 
      lines = {'shentendo✽'},
      col = 1,
      x0 = cam.x0 + (128/2) - ((10 * 4)/2),
      y0 = cam.y0 - 6,
      finish_y0 = cam.y0 + 128/2 - (2),
      counter = 0,
      time = 2 * 30,
      finished = false,
      update = function(self)
        if self.y0 == self.finish_y0 then 
          if self.counter == self.time then self.finished = true end 
          self.counter += 1
          return
        end
        self.y0 += 1
      end,
      draw = function(self)
        cls(7)
        print(self.lines[1],self.x0,self.y0,self.col)
      end
    },
    credits = {
      lines = {'code','art','and sfx','by your boi shen'},
      col = 1,
      counter = 0,
      time = 10 * 30,
      finished = false,
      update = function(self)
        if self.counter == self.time then
          self.finished = true
        end
        self.counter += 1
      end,
      draw = function(self)
        cls(7)
        print_text_centered(self.lines,cam,1)
      end
    },
    title = {
      draw = function(self)
        cls()
      end
    },
    draw = function(self)
      if not self.logo.finished then return self.logo:draw() end

      if not self.credits.finished then return self.credits:draw() end

      self.title:draw()
    end
  }

  
    
  
  selected_card:place_starting_card()
end

function game_update()
  intro.logo:update()
  intro.credits:update()
  -- pause_screen:update()
  -- if is_notice_board_or_pause_screen_showing() then return end
  -- z_button:update()
  -- selected_card:update()
  -- blink:update()
  -- for fruit in all(planted_fruits) do
  --   fruit:update()
  -- end
  -- card_slide_manager:update()
  -- adjust_selected_card_or_camera_position(selected_card,cam,card_slide_manager)
  -- camera(cam.x0,cam.y0)
end

function game_draw()
  cls(5)
  intro:draw()
  
  -- lawn:draw()

  -- for fruit in all(planted_fruits) do
  --   fruit:draw()
  -- end
  -- selected_card:draw()
  -- pause_screen:draw()
  -- notice_board:draw()
end

function view_orchard()
  game.update = view_orchard_update
  game.draw = view_orchard_draw
end

function view_orchard_update()
  for fruit in all(planted_fruits) do
    fruit:update()
  end
  notice_board:update()
  x_button:update()
  if x_button.is_just_released then
    game.update = show_scores_update
    game.draw = show_scores_draw
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
  blink:update()
  x_button:update()
  if x_button.is_just_released then
    camera(0,0)
    start_game()
  end
end

function show_scores_draw()
  cls()
  rank_screen:draw()
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000b3333b000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000003bbbbbbbbbb3000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000003bbbbbbbbbbb3300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000033bbb7bbbbbbb3b30000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000333b7777bbbbbbbbb3000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000bbbb7777bbbbbb33b33300000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000bbbb7b7bbbbbbbbb3333330000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000bbbb777bbbbbbb3b33333333000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000bbbbb7bbbbbbb33333333b33000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000003bbbbbbbbbbb33333333bbb3000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000033bbbb333b3b333333333bb33300000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000333bbbb3333333bbbbb3bbbb3300000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000033333b33333b3bbbbbbbbbbb3300000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000003333333333bbbbb7bbbbbbbb3300000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000033333333333bb7777bbbbbbb3300000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000033333333333b7777bbbbbbb33300000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000333b333b33bb7bbbbbbbb333000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000033bbb7bbb33bbbbbbbbb3333000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000333b777bb333bbbbbbbbb333000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000033bb7bbbbb33bbb333b3330000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000033bbbbbbbb33b333333300000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000033bbbbb33333333333000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000003bbb3333332333330000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000003b33333322233300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000333233222333000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000002224223000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
