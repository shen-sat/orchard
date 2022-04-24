pause_screen = {
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
  title = function(self,texts,title_text_length,x0,y0)
    local texts = texts
    local title_first_x = self:x0() + x0
    local title_first_y = self:y0() + y0
    local line_y = title_first_y + 2

    print(texts[1],title_first_x,title_first_y,self.title_color)
    line(self:left_margin(),line_y,title_first_x - 2,line_y,self.text_color)
    line(title_first_x + title_text_length,line_y,self:right_margin(),line_y,self.text_color)
    
    local counter_y = title_first_y
    for text in all(texts) do
      if not (text == texts[1]) then
        counter_y += 7
        print(text,self:left_margin(),counter_y,self.text_color)
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

    local card_data = deck.count_after_first_card_placement - #deck.cards
    self:title({'current game', 'score:'..score, 'card :'..card_data..'/'..deck.count_after_first_card_placement}, 12 * 4,40,9)

    local controls_text = {'controls', 'move card  : ➡️,⬇️,⬅️,⬆️','rotate card: tap z','place card : hold z + tap ⬇️'}
    self:title(controls_text,32,48,23 + 14)

    local rules_text = { 'rules','to place card, at least one','of its fruit must overlap a','matching fruit in orchard' }
    self:title(rules_text,20,54,23 + 14 + 21 + 8 + 5)
    
    spr(2,self:x0() + 20,self:y0() + 101,2,2)
    spr(4,self:x0() + 56,self:y0() + 99,2,2)
    spr(6,self:x0() + 92,self:y0() + 98,2,2)
    print('3points',self:x0() + 14,self:y0() + 114,text_color)
    print('6points',self:x0() + 50,self:y0() + 114,text_color)
    print('9points',self:x0() + 86,self:y0() + 114,text_color)
    print('3',self:x0() + 14,self:y0() + 114,2)
    print('6',self:x0() + 50,self:y0() + 114,2)
    print('9',self:x0() + 86,self:y0() + 114,2)
  end
}