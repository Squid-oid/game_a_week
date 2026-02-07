extends ButtonGrouper

func _on_start_pressed() -> void:
	_transition_call(Globals.query('Game'))

func _on_settings_pressed() -> void:
	_transition_call(Globals.query('Settings'))

func _on_quit_pressed() -> void:
	get_tree().quit()
