lawn = {
  pattern = {},
  load = function(self)
    bg_color = 3
    for x=orchard_x0,orchard_x1 - tile_size,16 do
      if bg_color == 3 then 
        --this is a representation of light and dark colors for the fillp function (https://seansleblanc.itch.io/pico-8-fillp-tool)
        bg_color = 179 
      else
        bg_color = 3
      end
      local next_x = x
      for y=orchard_y0,orchard_y1 - tile_size,16 do
        local next_y = y
        local coordinates = { x0 = next_x, y0 = next_y, col = bg_color }

        add(self.pattern,coordinates)
        if bg_color == 3 then 
          bg_color = 179
        else
          bg_color = 3
        end
      end
    end    
  end,
  draw = function(self)
    for square in all(self.pattern) do
      local x0 = square.x0
      local y0 = square.y0
      if square.col == 179 then fillp(0x8020) end
      rectfill(x0,y0,calculate_x1(x0,16),calculate_y1(y0,16),square.col)
      fillp()
    end
  end
}

lawn:load()