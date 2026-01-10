extends RigidBody3D
@export var turning_force := 125.0
@export var dampening := 82.5
@export var restoring := turning_force*0.6

@onready var axel := $Rotator as Generic6DOFJoint3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	# Steering input
	var steering := - Input.get_action_strength("turn_left") + Input.get_action_strength("turn_right")
	
	# Get axel for torqueing
	var axis = -global_basis.z
	
	# Manual dampening
	var steering_speed := angular_velocity.y
	var restoring_torque := steering_speed * dampening
	
	# Automatic Centering Effect
	if abs(steering) <= 0.05:
		var steering_angle := rotation.y
		restoring_torque += clamp(steering_angle, -0.5, 0.5) * restoring
	
	apply_torque(axis * (steering * turning_force + restoring_torque))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
