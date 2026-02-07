extends Button
class_name PathButton

@export var attached_text_edit : TextEdit

func _ready() -> void:
	if not attached_text_edit:
		push_warning("No Attached Text Edit")
		queue_free()
		
func fetch_text():
	return attached_text_edit.text
