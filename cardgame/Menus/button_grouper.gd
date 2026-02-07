extends Control
class_name ButtonGrouper 
'''A button grouper acts as a place to pin buttons, as well as giving the ability to attach a Transitioner through the inspector, and providing calls to it '''

@export var transitioner: Transitioner

func _transition_call(scene: String):
	if transitioner:
		transitioner.on_transition(scene)
