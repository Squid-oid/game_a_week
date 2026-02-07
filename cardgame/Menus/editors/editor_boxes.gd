extends Control

@export var editor : CardEditor

func _ready():
	if not editor:
		push_warning("EditorBoxes Lacks an attached editor")
		queue_free()


func _on_card_name_text_changed(emitter) -> void:
	editor.update_property('name', emitter.text)


func _on_card_editor_switched_card(_idx, data) -> void:
	$Name/CardName.text = data['name']
	$Description/Description.text = data['desc']	
	$TripletCluster/Type/Type.text = data['type']
	$TripletCluster/Targets/Targets.text = data['target_type']
	$TripletCluster/Cost/Cost.text = str(data['cost'])
	$Effects/Effects.text = str(data['func'])

func _on_description_text_changed(emitter) -> void:
	editor.update_property('desc', emitter.text)

func _on_cost_text_changed(emitter) -> void:
	var cost = int(emitter.text)
	editor.update_property('cost', cost)

func _on_targets_text_changed(emitter) -> void:
	editor.update_property('target_type', emitter.text)

func _on_type_text_changed(emitter) -> void:
	editor.update_property('type', emitter.text)


func _on_attempt_to_load_pressed(source: PathButton) -> void:
	var path = source.fetch_text()
	var texture = load(path)
	if texture:
		editor.update_property('image_path', path)
		editor.update_property('image', texture)
	else:
		print("No valid file found at specified path")


func _on_effects_text_changed(emitter) -> void:
	editor.update_property('func', emitter.text)
