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

function adjust_selected_card_or_camera_position(selected_card,cam)
  if selected_card:x1() > cam:x1() then
    local adjustment = selected_card:x1() - cam:x1()

    if btnp(4) then
      selected_card.x0 -= adjustment
    else
      cam.x0 += adjustment
    end
  elseif selected_card:y1() > cam:y1() then
    local adjustment = selected_card:y1() - cam:y1()

    if btnp(4) then
      selected_card.y0 -= adjustment
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