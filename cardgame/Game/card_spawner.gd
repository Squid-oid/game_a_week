extends Node
var num_presses = 0
var path = 'res://Game/CardHandling/cards/carddata/cards.json'
var cards 

func _ready():
	cards = DataCard.load_cards()
	
func _on_button_pressed() -> void:
	var data_card = cards[num_presses]
	num_presses = (num_presses + 1)%len(cards)
	$"../Hand".add_card(data_card.make_card_scene())
