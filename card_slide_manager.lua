card_slide_manager = {
  is_any_fruit_growing = false,
  selected_card_can_slide = true,
  check_any_fruit_growing = function(self)
    for fruit in all(planted_fruits) do
      if fruit.is_growing then self.is_any_fruit_growing = true end
    end
  end,
  --dirty fix for a bug: cards that are planted on on fruits that have already reached max age will cause card to "jump"
  check_any_fruit_pushing_max_age = function(self)
    local any_fruits_pushing_max_age = false
    for fruit in all(planted_fruits) do
      if fruit.is_pushing_max_age then 
        if not any_fruits_pushing_max_age then any_fruits_pushing_max_age = true end
        fruit.is_pushing_max_age = false
      end
    end

    if any_fruits_pushing_max_age then self.selected_card_can_slide = true end
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
    self:check_any_fruit_pushing_max_age()
    self:is_card_animation_finished()
  end
}