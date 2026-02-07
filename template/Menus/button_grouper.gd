extends Control
class_name ButtonGrouper

@export var transitioner: Transitioner

func _transition_call(scene: String):
	if transitioner:
		transitioner.on_transition(scene)
