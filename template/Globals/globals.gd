extends Node2D
static var global_dict = {}

func _ready() -> void:
	add('Main Menu', 'Menus/main_menu/main_menu.tscn')
	add('Settings', 'Menus/settings/settings.tscn')
	add('Game', 'Game/game.tscn')

func add(key, value):
	global_dict[key] = value
	return

func query(key):
	return global_dict[key]
