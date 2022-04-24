rank_screen = {
  x0 = function()
    return cam.x0
  end,
  y0 = function()
    return cam.y0
  end,
  width = 128,
  height = 128,
  col = 3,
  show = false,
  text_color = 1,
  title_color = 2,
  text_data = {
    'rank',
    {line = '< 25  : pal-tree', is_in_range = function(num) return (num < 25) end},
    {line = '25-29 : forget-apple', is_in_range = function(num) return (num >= 25 and num <= 29) end},
    {line = '30-34 : satisfac-tree', is_in_range = function(num) return (num >= 30 and num <= 34) end},
    {line = '35-39 : remark-apple', is_in_range = function(num) return (num >= 35 and num <= 39) end},
    {line = '40-44 : tree-mendous', is_in_range = function(num) return (num >= 40 and num <= 44) end},
    {line = '45-49 : plum-believable', is_in_range = function(num) return (num >= 45 and num <= 49) end},
    {line = '50 +  : pear-fect', is_in_range = function(num) return (num >= 50) end}
  },
  left_margin = function(self)
    return self:x0() + 9
  end,
  right_margin = function(self)
    return self:x0() + (128 - 10)
  end,
  x1 = function(self)
    return calculate_x1(self:x0(),self.width)
  end,
  y1 = function(self)
    return calculate_y1(self:y0(),self.height)
  end,
  title = function(self,text_data,title_text_length,x0,y0)
    local text_data = text_data
    local title_first_x = self:x0() + x0
    local title_first_y = self:y0() + y0
    local line_y = title_first_y + 2

    print(text_data[1],title_first_x,title_first_y,self.title_color)
    line(self:left_margin(),line_y,title_first_x - 2,line_y,self.text_color)
    line(title_first_x + title_text_length,line_y,self:right_margin(),line_y,self.text_color)
    
    local counter_y = title_first_y
    for datum in all(text_data) do
      if not (datum == text_data[1]) then
        counter_y += 7
        if datum.is_in_range(score) and blink:blink() then
          print(datum.line,self:left_margin(),counter_y,7)
        else
          print(datum.line,self:left_margin(),counter_y,self.text_color)  
        end
      end
    end
  end,
  update = function(self)
  end,
  draw = function(self)
    --brown fill
    rectfill(self:x0(),self:y0(),self:x1(),self:y1(),4)
    --blue fill
    rectfill(self:x0() + 6,self:y0() + 6,self:x1() - 6,self:y1() - 6,1)
    --green fill
    rectfill(self:x0() + 7,self:y0() + 7,self:x1() - 7,self:y1() - 7,self.col)

    --top details
    rectfill(self:x0(),self:y0(),calculate_x1(self:x0(),2),calculate_y1(self:y0(),2),9)
    line(self:x0() + 1,self:y0() + 4,self:x0() + 127,self:y0() + 4,2)
    line(self:x0() + 0,self:y0() + 5,self:x0() + 127,self:y0() + 5,2)
    --left details
    line(self:x0(),self:y0() + 6,self:x0() + 5,self:y0() + 6,2)
    pset(self:x0(),self:y0() + 7,9)
    line(self:x0() + 4,self:y0() + 7,self:x0() + 4,self:y1() - 6,2)
    line(self:x0() + 5,self:y0() + 7,self:x0() + 5,self:y1() - 6,2)
    --bottom details
    rectfill(self:x0(),self:y1() - 5,self:x0() + 1,self:y1() - 4,9)
    line(self:x0() + 1,self:y0() + 126,self:x0() + 127,self:y0() + 126,2)
    line(self:x0(),self:y0() + 127,self:x0() + 127,self:y0() + 127,2)
    line(self:x0() + 126,self:y0() + 123,self:x0() + 126,self:y0() + 127,2)
    --right border
    pset(self:x1() - 5,self:y0() + 6,9)
    line(self:x0() + 126,self:y0() + 1,self:x0() + 126,self:y1() - 6,2)
    line(self:x0() + 127,self:y0(),self:x0() + 127,self:y0() + 127,2)

    self:title(self.text_data, 4 * 4,56,9)
    print('press x to retry',cam.x0 + 32,cam.y0 + 88,1)
  end
}