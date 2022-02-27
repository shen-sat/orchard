card_slide_manager = {
  is_any_fruit_growing = false,
  selected_card_can_slide = true,
  check_any_fruit_growing = function(self)
    for fruit in all(planted_fruits) do
      if fruit.is_growing then self.is_any_fruit_growing = true end
    end
  end,
  check_fruits_stopped_growing = function(self)
    result = true
    for fruit in all(planted_fruits) do
      if fruit.is_growing then result = false end
    end
    
    if result and self.is_any_fruit_growing then
      self.is_any_fruit_growing = false
      self.selected_card_can_slide = true
    end
  end,
  is_card_animation_finished = function(self)
    if selected_card.y0 == selected_card.deal_y0() and self.selected_card_can_slide then
      self.selected_card_can_slide = false
    end
  end,
  update = function(self)
    self:check_any_fruit_growing()
    self:check_fruits_stopped_growing()
    self:is_card_animation_finished()
  end
}