extends RigidBody3D
@export var lean_limit := PI/8
@export var max_strength := 450
@export var spring_ratio := 1.5  # How much force the autostab has compared to the player max force
@export var damping_ratio = 1.15  # The damping coeffecient of the autostab, slight overdamp since the wheels have mass too and the player will likely add forces..
@export var frontal_damping = 180
@export var drive_correction = 20

@onready var spring := spring_ratio * max_strength
@onready var damping := 2*sqrt((spring + (1.5 * mass * ProjectSettings.get_setting("physics/3d/default_gravity")))*(1.5 * mass)) # Spring mass system, linearized around 0, 1.5 is approximation of height above ground
@onready var gravity_direction = ProjectSettings.get_setting("physics/3d/default_gravity_vector").normalized() # Get the gravity direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body
	
func _physics_process(delta: float) -> void:
	# Steering input
	var steering := + Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	
	# Get axel for torqueing
	var axis = global_basis.z
	var up = global_basis.y
	var world_up = -gravity_direction.normalized()
	
	# Find lean angle, to do this we find a plane orthog to z, composed of the bike y, and an ortog vector
	# var right = axis.cross(up) # Plane is defined by [up, right]
	var projected_up = (world_up - axis * world_up.dot(axis)).normalized() # Both normalized -> projection onto plane / space = vector - projection of vector onto orthog to plane
	var lean_angle = up.signed_angle_to(projected_up, axis)
	
	# Create linear fall off lean force
	var free_rotation = 0
	if steering > 0:
		free_rotation = clamp(lean_limit - lean_angle, 0, lean_limit)/lean_limit
	elif steering < 0:
		free_rotation = clamp(lean_limit + lean_angle, 0, lean_limit)/lean_limit
	var steering_torque = steering * max_strength * free_rotation
	
	# Emergency boost
	if abs(steering) > PI/4:
		steering *= 2*(steering-PI/4)/(PI/4) + 1
		
	# Create automatic righting spring damping system
	var spring_torque = lean_angle*spring
	var damping_torque = -angular_velocity.dot(axis)*damping
	
	apply_torque(global_basis.z * (steering_torque + spring_torque + damping_torque))
	
	# Crate automatic front back frame damping as well as counter torque to front tire drive torque
	var drive := -Input.get_action_strength("forward") + Input.get_action_strength("backward")
	var axis_r = global_basis.x
	var damping_torque_r = -angular_velocity.dot(axis_r)*frontal_damping
	apply_torque(global_basis.x * (damping_torque_r + drive * drive_correction))
	apply_central_force(drive*global_basis.z * max_strength / 4)

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
