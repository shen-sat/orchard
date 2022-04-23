intro = {
  logo = { 
    lines = {'shentendo✽'},
    background_col = 3,
    text_col = 1,
    x0 = cam.x0 + (128/2) - ((10 * 4)/2),
    y0 = cam.y0 - 6,
    finish_y0 = cam.y0 + (128/2) - (3),
    counter = 0,
    time = 3 * 30,
    finished = false,
    increment_y0 = function(self) self.y0 += 1 end,
    update = function(self)
      if not (self.y0 == self.finish_y0) then return self:increment_y0() end         

      self.counter += 1
      if self.counter >= self.time then self.finished = true end
    end,
    draw = function(self)
      cls(self.background_col)
      print(self.lines[1],self.x0,self.y0,self.text_col)
    end
  },
  credits = {
    lines = {'code','art','and sfx','by your boi shen'},
    background_col = 3,
    text_col = 1,
    counter = 0,
    time = 5 * 30,
    fade_counter = 0,
    fade_step = 0,
    finished = false,
    start_fade = false,
    pal_data =  {3,1,0,5,6},
    calculate_fade = function(self)
      local num = self.fade_counter % 2
      if num == 0 then self.fade_step += 1 end
      self.fade_counter += 1
      if self.fade_step > #self.pal_data then self.finished = true end
    end,
    update = function(self)
        self.counter += 1
        if self.counter > self.time then self.finished = true end
    end,
    draw = function(self)
      if self.start_fade then
        rectfill(0,0,127,127,self.pal_data[self.fade_step])  
        return
      end
      rectfill(0,0,127,127,self.background_col)
      print_text_centered(self.lines,cam,self.text_col)
    end
  },
  title = {
    title_blink_counter = 0,
    counter = 0,
    time = 4 * 30,
    fade_counter = 0,
    fade_step = 0,
    change_state = function()
      game.update = game_update
      game.draw = game_draw
    end,
    pal_data = {7,6,5,0,0,1,5,3},
    calculate_fade = function(self)
      local num = self.fade_counter % 5
      if num == 0 then self.fade_step += 1 end
      self.fade_counter += 1
      if self.fade_step > #self.pal_data then self.change_state() end
    end,
    update = function(self)
      if not self.start_fade then
        if btnp(5) then 
          self.start_fade = true
          music(-1, 4000)
        end
      end
      
      if self.start_fade then self:calculate_fade() end
    end,
    draw = function(self)
      if self.start_fade then
        rectfill(0,0,127,127,self.pal_data[self.fade_step])
        return
      end
      rectfill(0,0,127,127,7)
      spr(128,20,25,13,6)
      rectfill(20 + (16*6),25,127,25 + (16*2),7)
      self.title_blink_counter += 1

      if self.title_blink_counter > 80 then 
        self.title_blink_counter = 0
      elseif self.title_blink_counter > 40 then 
        spr(140,20 + 28,26,3,3)
      end

      if self.counter < self.time then
        self.counter += 1
      else
        print('press x to start',35,85,2)
      end
    end
  },
  update = function(self)
    blink:update()

    if not self.logo.finished then return self.logo:update() end

    if not self.credits.finished then return self.credits:update() end

    self.title:update()
  end,
  draw = function(self)
    if not self.logo.finished then return self.logo:draw() end

    if not self.credits.finished then return self.credits:draw() end

    self.title:draw()
  end
}