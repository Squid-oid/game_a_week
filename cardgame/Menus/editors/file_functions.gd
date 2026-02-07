extends Control

@export var path_edit : TextEdit
@export var editor : Node2D

func _ready() -> void:
	if not path_edit:
		push_warning("No TextEdit for file functions")
		queue_free()
		
	if not editor:
		push_warning("No editor for file functions")
		queue_free()

func _on_save_pressed() -> void:
	var path = path_edit.text
	if not path:
		print("No Path")
		return
	
	DataCard.save_cards(editor.cards, path)
	
func _on_load_pressed():
	editor.clear()
	var path = path_edit.text
	var cards = DataCard.load_cards(path)
	for card in cards:
		editor.quiet_attach(card)
