starting_cards = {{ -- Nine two-sided cards
    {copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(lemon)}, -- 1
    {copy_table(apple), copy_table(berry), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(lemon)}  -- 2
  }, {
    {copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple), copy_table(berry)}, -- 3
    {copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(lemon), copy_table(apple), copy_table(berry)}  -- 4
  }, {
    {copy_table(apple), copy_table(lemon), copy_table(berry), copy_table(berry), copy_table(lemon), copy_table(apple)}, -- 5
    {copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(berry), copy_table(lemon), copy_table(apple)}  -- 6
  }, {
    {copy_table(lemon), copy_table(apple), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(berry)}, -- 7
    {copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry)}  -- 8
  }, {
    {copy_table(berry), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(apple)}, -- 9
    {copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple)}  -- 10
  }, {
    {copy_table(berry), copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple)}, -- 11
    {copy_table(berry), copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(apple), copy_table(lemon)}  -- 12
  }, {
    {copy_table(apple), copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(berry), copy_table(lemon)}, -- 13
    {copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon)}  -- 14
  }, {
    {copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry), copy_table(lemon)}, -- 15
    {copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(apple), copy_table(berry), copy_table(lemon)}  -- 16
  }, {
    {copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry), copy_table(berry), copy_table(lemon)}, -- 17
    {copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry), copy_table(lemon), copy_table(berry)}  -- 18
  }
}

shuffled_cards = {}
no_of_starting_cards = #starting_cards

for _i=1, no_of_starting_cards  do
	local card = rnd(starting_cards) -- Get a random card
	local side = rnd(card)           -- Select random side of that card
	del(starting_cards, card)
	add(shuffled_cards, side)
end

deck = {
	cards = shuffled_cards,
	count_after_first_card_placement = #shuffled_cards - 1,
	count = function(self)
		return #self.cards
	end
}