extends Node2D
class_name CardEditor

signal updated_card
signal switched_card

var cards : Array[DataCard]
var active_data_card : DataCard
var active_card_scene : Node2D

func _ready() -> void:
	cards = []

func attach_card(card: DataCard):
	cards.append(card)
	active_data_card = card
	instant_card()
	$Cards.add_item(card.data['name'])
	fire_switch()
	
func quiet_attach(card: DataCard):
	cards.append(card)
	$Cards.add_item(card.data['name'])
	
func instant_card():
	if active_card_scene:
		active_card_scene.queue_free()
	active_card_scene = active_data_card.make_card_scene()
	%CardHandle.add_child(active_card_scene)

func delete_card():
	if not active_data_card:
		print('No Active Card')
		return
	else:
		active_card_scene.queue_free()
		active_data_card.queue_free()
		var idx = cards.find(active_data_card)
		cards.remove_at(idx)
		$Cards.remove_item(idx)	

func clear():
	while len(cards) > 0:
		switch_card(0)
		delete_card()

func update_property(property, state):
	if not active_data_card:
		return
	active_data_card.data[property] = state
	fire_update()
	instant_card()

func switch_card(idx):
	active_data_card = cards[idx]
	instant_card()
	fire_switch()

func fire_switch():
	emit_signal('switched_card',  cards.find(active_data_card), active_data_card.data)

func fire_update():
	emit_signal('updated_card',  cards.find(active_data_card), active_data_card.data)
