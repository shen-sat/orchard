blink = {
  blink = function(self)
    return self.time < 9
  end,
  time = 0,
  update = function(self)
    self.time = (self.time + 1) % 18
  end
}