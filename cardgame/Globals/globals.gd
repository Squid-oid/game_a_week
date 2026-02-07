extends Node2D
static var global_dict = {}

# We use globals sparingly, mostly to store scene locations so that we have a single place to shift them in refactoring
func _ready() -> void:
	add('Main Menu', 'Menus/main_menu/main_menu.tscn')
	add('Settings', 'Menus/settings/settings.tscn')
	add('Game', 'Game/game.tscn')
	add('Card', 'Game/CardHandling/cards/card.tscn')
	add('Card Editor' ,'Menus/editors/card_editor.tscn')

func add(key, value):
	global_dict[key] = value
	return

func query(key):
	return global_dict[key]
