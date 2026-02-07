extends Path2D
class_name Hand

# By keeping an ordered list of cards we can trust the hand fan will be consistent, and expose the hand by index which can be useful later.
@onready var cards : Array[Card]
@onready var card_to_pivot : Dictionary[Card, PathFollow2D]
@export var game : Node2D

func _ready() -> void:
	card_to_pivot = {}
	cards = []

func add_card(card):
	# Create a new path follow point for the card to sit on
	var pivot = PathFollow2D.new()
	add_child(pivot)
	pivot.add_child(card)
	
	# List of cards and dict to look up pivot from card -> We have both a consistent ordering, and easy acsess to everything
	cards.append(card)
	card_to_pivot[card] = pivot
	
	# Connect the card click signal to removing the card
	card.connect("clicked", remove)
	if game:
		game.add_card(card)
	_refresh_fan()
	
func remove(card_or_idx):
	# Remove a given card, alternatively the card at spot idx
	# We can get either an int or an index here (for easier future acsess), so we need to first get the card, and drop it from the hand list to prevent future null references
	var card = null
	if card_or_idx is int:
		card = cards[card_or_idx]
		cards.remove_at(card_or_idx)
	elif card_or_idx is Card:
		var idx = cards.find(card_or_idx)
		if idx == -1:
			return
			
		card = card_or_idx
		cards.remove_at(idx)
	else:
		push_warning('Non Card or Int passed to Hand for removal')
		return
	
	# Then since we have the card we can find the associated pivot, and queue_free it. Since the card is a child of the pivot this deletes it unless we've reparented it to a new node first.
	var pivot = card_to_pivot[card]
	card_to_pivot.erase(card)
	pivot.queue_free()
	_refresh_fan()
	

func _refresh_fan():
	# Refresh the fan, going over each PathFollow and spacing them equally.
	var num_cards = len(cards)
	for i in num_cards:
		var pivot = card_to_pivot[cards[i]]
		pivot.progress_ratio = ((i+0.5)/num_cards - 0.5) * (num_cards / (num_cards + 2.0)) + 0.5
