extends Node2D
class_name CardPlay

var data
var play_cases = {'monster': play_monster_to_pos, 'spell': play_spell_to_pos}

func _init(card: Card) -> void:
	data = card.progenitor.data
	data['card_gfx'] = card.get_gfx().duplicate()
	add_child(data['card_gfx'])
	
func play_card_to_pos(node: Node2D):
	var type = data['type'].to_lower()
	if play_cases.has(type):
		play_cases[type].call(node)
	else:
		print("Unhandled Card Type, valid types are 'monster', 'spell'")

func play_monster_to_pos(node: Node2D):
	if node.get_children().any(isCardPlay):
		return
	else:
		node.add_child(self)
	
func play_spell_to_pos(node: Node2D):
	if node.get_children().any(isCardPlay):
		print('Spell!')
	else:
		return

static func isCardPlay(obj):
	return obj is CardPlay
