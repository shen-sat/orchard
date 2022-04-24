notice_board = {
  x0 = function(self)
    return cam.x0 + (64 - 22)  
  end,
  y0 = function(self)
    return cam.y0 + (128 - 17)
  end,
  width = 22 * 2,
  height = 17,
  inner_col = 4,
  outer_col = 1,
  x1 = function(self)
    return calculate_x1(self:x0(),self.width)
  end,
  y1 = function(self)
    return calculate_y1(self:y0(),self.height)
  end,
  show = true,
  end_text = {'press x to','continue'},
  text = {'press and','hold x'},
  update = function(self)
    self.text = self.end_text
    if not self.show then self.show = true end
  end,
  draw = function(self)
    if not self.show then return end

    rectfill(self:x0(),self:y0(),self:x1(),self:y1(),self.inner_col)
    rect(self:x0(),self:y0(),self:x1(),self:y1(),self.outer_col)
    line(self:x0() + 1,self:y1(),self:x1() - 1,self:y1(),self.inner_col)
    local counter = 0
    for line in all(self.text) do
      print(line,self:x0() + 2,self:y0() + 2 + counter,self.outer_col)
      counter += 7
    end
  end
}