extends Camera3D

@onready var positions = [Vector3(0.0, 2.7, -7.1), Vector3(0.0, 12, 0.0), Vector3(10, 1.3, 0)]
@onready var i = 0
@export var follow_target: Node3D
@export var look_target: Node3D

func _process(delta):
	if Input.is_action_just_pressed("cam_swap"):
		i = (i+1)%len(positions)
		position = positions[i]
		
	look_at(look_target.global_position)
