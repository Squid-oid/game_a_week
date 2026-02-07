extends Node
class_name DataCard

var card_scene
static var SAVE_LOCATION := "res://Game/CardHandling/cards/carddata/cards.json"
var data := {'name': null, 'desc': null, 'type': null, 'target_type': null, 'cost': null, 'func': null, 'image_path': null, 'image': null}

func _init(dat: Dictionary) -> void:
	card_scene = load('res://' + Globals.query('Card'))
	data.merge(dat, true)
	if data['image_path']:
		data['image'] = load(data['image_path'])
	else:
		data['image'] = null
	'''
	var data = {
		"name" : ... : String
		"desc" : ... : String
		
		"type" : ... : String in {"Minion", "Spell"}
		"target_type" : ... : String in {"Self", "Minion", "Enemy", "Enemy Minion"}
		"cost" : ... : int
		"func" : ... : String
		
		"image_path" : ... : String
		"image" : ... : Texture2D
	'''

func make_card_scene():
	var scene = card_scene.instantiate()
	scene.set_properties(self)
	return scene

''' Data Loading and Saving of Cards to a file '''
func stringify():
	var sub_data = data.duplicate()
	if sub_data.has("image"):
		sub_data.erase("image")
	var json_string = JSON.stringify(sub_data)
	return json_string
	
static func save_cards(cards: Array[DataCard], location := SAVE_LOCATION):
	var save_file = FileAccess.open(location, FileAccess.WRITE)
	for card in cards:
		save_file.store_line(card.stringify())

static func load_card(line: String):
	var parser = JSON.new()
	var parse_result = parser.parse(line)
	if not parse_result == OK:
		push_warning("JSON Parse Error: " + parser.get_error_message() + " in " + line + " at line " + str(parser.get_error_line()))
		return {}
	return parser.data

static func load_cards(path: String = SAVE_LOCATION):
	var cards = []
	var save_file = FileAccess.open(path, FileAccess.READ)
	if not save_file:
		push_warning('No Valid File Loaded')
		return []
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var card_data = load_card(json_string)
		if not card_data == {}:
			var new_card = DataCard.new(card_data)
			cards.append(new_card)
	return cards
