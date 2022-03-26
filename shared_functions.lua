function calculate_x1(x0, width)
  return x0 + width - 1
end

function calculate_y1(y0, height)
  return y0 + height - 1
end

function reverse_table(table)
  local result = {}
  local counter = #table
  for value in all(table) do
    add(result,table[counter])
    counter -= 1
  end
  return result
end

function adjust_selected_card_or_camera_position(selected_card,cam,manager)
  if manager.selected_card_can_slide or manager.is_any_fruit_growing then return end

  if selected_card:x1() > cam:x1() then
    local adjustment = selected_card:x1() - cam:x1()

    if z_button.is_just_released then
      selected_card.x0 -= adjustment
      selected_card:update_fruits() -- card has adjusted, so fruit need to be adjusted too
    else
      cam.x0 += adjustment
    end
  elseif selected_card:y1() > cam:y1() then
    local adjustment = selected_card:y1() - cam:y1()

    if z_button.is_just_released then
      selected_card.y0 -= adjustment
      selected_card:update_fruits() -- card has adjusted, so fruit need to be adjusted too
    else
      cam.y0 += adjustment
    end
  elseif selected_card.x0 < cam.x0 then
    local adjustment = cam.x0 - selected_card.x0
    
    cam.x0 -= adjustment
  elseif selected_card.y0 < cam.y0 then
    local adjustment = cam.y0 - selected_card.y0
    
    cam.y0 -= adjustment
  end
end

function copy_table(table)
  new_table = {}
  for k,v in pairs(table) do
    new_table[k] = v
  end

  return new_table
end

function reverse_table(table)
  new_table = {}

  counter = #table
  for v in all(table) do
    add(new_table,table[counter])
    counter -= 1
  end

  return new_table
end

function is_game_over()
  return deck:count() < 1
end

function is_notice_board_or_pause_screen_showing()
  return (notice_board.show or pause_screen.show)
end

-- assumes no line is wider than screen width
function print_text_centered(lines,camera,col)
  local cam_x = camera.x
  local cam_y = camera.y
  local lines_count = #lines

  local y0 = (128/2) - ((lines_count * 6)/2)

  local x0 = 128
  for line in all(lines) do
    local character_count = #line

    local temp_x0 = (128/2) - ((character_count * 4)/2)
    if temp_x0 < x0 then x0 = temp_x0 end
  end

  print(lines[1],x0,y0,col)
  for line in all(lines) do
    if not (line == lines[1]) then print(line) end
  end
end