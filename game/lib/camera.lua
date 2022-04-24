cam = {
  x0 = 0,
  y0 = 0,
  width = screen_width,
  height = screen_height,
  x1 = function(self)
    return calculate_x1(self.x0, self.width)
  end,
  y1 = function(self)
    return calculate_y1(self.y0, self.height)
  end
}