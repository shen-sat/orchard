pause_screen = {
  x0 = 0,
  y0 = 0,
  width = 128,
  height = 128,
  col = 3,
  show = false,
  text_color = 1,
  title_color = 2,
  left_margin = 9,
  right_margin = 128 - 10,
  x1 = function(self)
    return calculate_x1(self.x0,self.width)
  end,
  y1 = function(self)
    return calculate_y1(self.y0,self.height)
  end,
  title = function(self,texts,title_text_length,x0,y0)
    local texts = texts
    local title_first_x = x0
    local title_first_y = y0
    local line_y = title_first_y + 2

    print(texts[1],title_first_x,title_first_y,self.title_color)
    line(self.left_margin,line_y,title_first_x - 2,line_y,self.text_color)
    line(title_first_x + title_text_length,line_y,self.right_margin,line_y,self.text_color)
    
    local counter_y = title_first_y
    for text in all(texts) do
      if not (text == texts[1]) then
        counter_y += 7
        print(text,self.left_margin,counter_y,self.text_color)
      end
    end
  end,
  update = function(self)
    if btn(5) then 
      self.show = true
      if notice_board.show then notice_board.show = false end
    else
      self.show = false
    end
  end,
  draw = function(self)
    if not self.show then return end
    --brown fill
    rectfill(self.x0,self.y0,self:x1(),self:y1(),4)
    --blue fill
    rectfill(self.x0 + 6,self.y0 + 6,self:x1() - 6,self:y1() - 6,1)
    --green fill
    rectfill(self.x0 + 7,self.y0 + 7,self:x1() - 7,self:y1() - 7,self.col)

    --top details
    rectfill(0,0,1,1,9)
    line(1,4,127,4,2)
    line(0,5,127,5,2)
    --left details
    line(0,6,5,6,2)
    pset(0,7,9)
    line(4,7,4,self:y1() - 6,2)
    line(5,7,5,self:y1() - 6,2)
    --bottom details
    rectfill(0,self:y1() - 5,1,self:y1() - 4,9)
    line(1,126,127,126,2)
    line(0,127,127,127,2)
    line(126,123,126,127,2)
    --right border
    pset(self:x1() - 5,self.y0 + 6,9)
    line(126,1,126,self:y1() - 6,2)
    line(127,0,127,127,2)

    local text_color = 1
    local title_color = 7
    local left_margin = 9
    local right_margin = 128 - 9

    self:title({'current game', 'score:', 'card :'}, 12 * 4,40,9)

    local controls_text = {'controls', 'move card  : ➡️,⬇️,⬅️,⬆️','rotate card: tap z','place card : hold z + tap ⬇️'}
    self:title(controls_text,32,48,23 + 14)

    local rules_text = { 'rules','to place card, at least one','of its fruit must overlap a','matching fruit in orchard' }
    self:title(rules_text,20,54,23 + 14 + 21 + 8 + 5)
    
    spr(2,20,101,2,2)
    spr(4,56,99,2,2)
    spr(6,92,98,2,2)
    print('3points',14,114,text_color)
    print('6points',50,114,text_color)
    print('9points',86,114,text_color)
    print('3',14,114,2)
    print('6',50,114,2)
    print('9',86,114,2)
  end
}