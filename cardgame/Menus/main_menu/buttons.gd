extends ButtonGrouper # Buttongrouper gives the function _transition_call, which passes off transitions to an editor attached transitioner

# The main menu buttons call for transitions or quitting
func _on_start_pressed() -> void:
	_transition_call(Globals.query('Game'))

func _on_settings_pressed() -> void:
	_transition_call(Globals.query('Settings'))

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_editor_pressed() -> void:
	_transition_call(Globals.query('Card Editor'))
