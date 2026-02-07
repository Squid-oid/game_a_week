extends Node2D

''' Remove these nodes for final release? '''
@export var debugging : bool

func _ready() -> void:
	if debugging:
		return
	queue_free()
