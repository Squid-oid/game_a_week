extends ButtonGrouper
@export var editor : CardEditor

func _ready():
	if not editor:
		push_warning("EditorButtons Lacks an attached editor")
		queue_free()

func _on_create_new_card_pressed() -> void:
	var data = {}
	data['name'] = 'New Card'
	data['desc'] = ''
	
	data['type'] = ''
	data['target_type'] = ''
	data['func'] = ''
	data['cost'] = 0
	
	data['image_path'] = null
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
	var new_data_card = DataCard.new(data)
	editor.attach_card(new_data_card)

func _on_activate_selected_card_pressed() -> void:
	editor.instant_card()

func _on_main_menu_pressed() -> void:
	_transition_call(Globals.query('Main Menu'))

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_delete_pressed() -> void:
	editor.delete_card()
