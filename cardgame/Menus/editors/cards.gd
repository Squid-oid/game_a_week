extends ItemList

func _on_card_editor_updated_card(idx, data) -> void:
	set_item_text(idx, data['name'])
