x_button = {
  is_down = false,
  is_just_released = false, 
  update = function(self)
    if self.is_just_released then self.is_just_released = false end

    if not self.is_down and btn(5) then 
      self.is_down = true
    elseif self.is_down and not btn(5) then 
      self.is_down = false
      self.is_just_released = true
    end
  end
}