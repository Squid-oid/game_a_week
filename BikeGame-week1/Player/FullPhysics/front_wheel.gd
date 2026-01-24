extends RigidBody3D
@onready var hub = $Hub as Generic6DOFJoint3D
@export var max_torque = 25

func _physics_process(delta: float) -> void:
	# Steering input
	var steering := - Input.get_action_strength("forward") + Input.get_action_strength("backward")
	
	# Get axel for torqueing
	var axis = hub.global_basis.x
	apply_torque(axis * steering * max_torque)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
