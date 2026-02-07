extends Node2D

func add_card(card : Card):
	card.connect("clicked", play_card)
	
func play_card(card: Card):
	var card_player = card.get_card_play()
	if card_player:
		$Side.connect("position_clicked", card_player.play_card_to_pos)
	
