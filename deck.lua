card_one = { copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry) }
card_two = { copy_table(lemon), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry) }
card_three = { copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry) }
card_four = { copy_table(berry), copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple) }
card_five = { copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple), copy_table(berry) }
card_six = { copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry) }
card_seven = { copy_table(lemon), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry) }
card_eight = { copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry) }
card_nine = { copy_table(apple), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(lemon), copy_table(apple) }

starting_cards = { card_one, card_two, card_three, card_four, card_five, card_six, card_seven, card_eight, card_nine }
shuffled_cards = {}
counter = #starting_cards

for c=1,counter do
  local i = flr(rnd(#starting_cards)) + 1
  local card = starting_cards[i]
  del(starting_cards,card)
  add(shuffled_cards,card)
end


deck = {
	cards = shuffled_cards,
	count = function(self)
		return #self.cards
	end
}