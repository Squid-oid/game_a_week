extends ButtonGrouper

# Just like the main menu button grouper
func _on_main_menu_pressed() -> void:
	_transition_call(Globals.query('Main Menu'))
	
func _on_quit_pressed() -> void:
	get_tree().quit()
