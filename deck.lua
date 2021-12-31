card_one = { copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry) }
card_two = { copy_table(lemon), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry) }
card_three = { copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry) }
card_four = { copy_table(berry), copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple) }
card_five = { copy_table(berry), copy_table(apple), copy_table(lemon), copy_table(lemon), copy_table(apple), copy_table(berry) }
card_six = { copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(lemon), copy_table(berry) }
card_seven = { copy_table(lemon), copy_table(lemon), copy_table(berry), copy_table(apple), copy_table(apple), copy_table(berry) }
card_eight = { copy_table(lemon), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(apple), copy_table(berry) }
card_nine = { copy_table(apple), copy_table(apple), copy_table(berry), copy_table(lemon), copy_table(lemon), copy_table(apple) }

deck = {
	cards = { card_two, card_three, card_four, card_five, card_six, card_seven, card_eight, card_nine },
	count = function(self)
		return #self.cards
	end
}