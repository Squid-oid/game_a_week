extends CharacterBody3D
@export var speed = 0
@export var turn_rate = 0.05
@export var gravity = 9.8
@export var acceleration = 55
@export var breaking = 55
@export var friction = 1.2
@export var turning_friction = 40
@export var wheel_dist_to_min_radius_ratio = 1.2
@export var max_steer = PI/6

var target_velocity = Vector3.ZERO
var target_angular = Vector3.ZERO
@onready var inv_radius = 0
@onready var inv_min_radius = ($FrontColl.position.z - $BackColl.position.z)*wheel_dist_to_min_radius_ratio
@onready var drawing = false
@onready var drawing2 = false

@onready var caster = deg_to_rad(20)
@onready var wheelbase = ($FrontColl.position.z - $BackColl.position.z)*0.8
@onready var theta_func = func(r, spd):
	var max_lean = max_steer*(2 - (1 - spd/(acceleration/friction)))
	return clamp(atan(spd**2/(gravity*r))*0.8, -max_lean, max_lean)
	
@onready var steering_angle = func(r, lean):
	if r == INF:
		return 0
	return clamp((wheelbase * cos(caster))/(r * cos(lean/0.8)), -max_steer, max_steer)
@onready var frame = $Frame
@onready var base_frame_rotation = frame.basis
@onready var axel = $Frame/Axel_Rotator/Align
@onready var base_axel_rotation = axel.basis
@onready var floor_normal = up_direction
@onready var new_direction = Basis()
@onready var t = 1
@onready var eps = 0.01
@onready var theta = 0
@onready var frotation = 0
@onready var angle = 0
@onready var arotation = 0
@onready var radius = INF

func _physics_process(delta):
	var direction = Vector3()
	var push = 0
	var pull = 0
	var dt = 0.25
	# Add gravity	
	if is_on_floor() and velocity.y <= 0:
		if Input.is_action_pressed("jump"):
			velocity.y = 5
		velocity.y -= gravity * delta 	
		var nfloor_normal = get_floor_normal().normalized()
		if (basis.y - nfloor_normal).length() > eps and t >= 1:
			t = 0
			basis = basis.slerp(new_direction, t)
			floor_normal = nfloor_normal
		if t < 1:
			new_direction.y = nfloor_normal.normalized()
			new_direction.z = (basis.z - basis.z.dot(floor_normal)*basis.z).normalized()
			new_direction.x = -new_direction.z.cross(new_direction.y).normalized()
			new_direction = new_direction.orthonormalized()
			t += dt
			basis = basis.slerp(new_direction, t)
		else:
			t += dt
	else:
		floor_normal = up_direction
		velocity.y -= gravity*delta
		var inv_turn_des = -(turn_rate*sign(inv_radius)*delta)*.5
		inv_radius += inv_turn_des
		inv_radius = clamp(inv_radius, -1/inv_min_radius, 1/inv_min_radius)
		if abs(inv_radius) < abs(inv_turn_des):
			inv_radius = 0
			# Set frame visual rotation
		radius = INF
		if inv_radius != 0:
			radius = 1/inv_radius
		theta = theta_func.call(radius, speed)
		frotation = base_frame_rotation.rotated(Vector3(0,0,1), theta)
		angle = steering_angle.call(radius, theta)
		arotation = base_axel_rotation.rotated(Vector3(0,1,0), angle)
		frame.basis = frotation
		axel.basis = arotation
		move_and_slide()
		return

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("turn_right"):
		direction.x += 1
	if Input.is_action_pressed("turn_left"):
		direction.x -= 1
	if Input.is_action_pressed("forward"):
		push = 1
	if Input.is_action_pressed("backward"):
		pull = 1

		
	if abs(inv_radius) < 1e-20:
		inv_radius = 1e-12 * direction.x
	if abs(direction.x) > 1e-20:
		var inv_turn_des = (turn_rate*direction.x*delta)
		inv_radius = (inv_radius + inv_turn_des*abs(inv_radius)*inv_min_radius*0.8 + 0.3*inv_turn_des + 4*inv_turn_des*(0.95 - speed/(acceleration/friction)))
		inv_radius = clamp(inv_radius, -1/inv_min_radius, 1/inv_min_radius)
	if (abs(direction.x) == 0):
		var inv_turn_des = -(turn_rate*sign(inv_radius)*delta)*.2
		inv_radius = (inv_radius + inv_turn_des*abs(inv_radius)*inv_min_radius*0.7 + 0.3*inv_turn_des + 4*inv_turn_des*(0.95 - speed/(acceleration/friction)))
		inv_radius = clamp(inv_radius, -1/inv_min_radius, 1/inv_min_radius)
		if abs(inv_radius) < abs(inv_turn_des*abs(inv_radius)*inv_min_radius*0.7 + 0.3*inv_turn_des + 4*inv_turn_des*(0.95 - speed/(acceleration/friction))):
			inv_radius = 0
	else:
		pass
	
	if drawing:
		drawing.queue_free()
	if drawing2:
		drawing2.queue_free()
	
	radius = INF
	var function = NAN
	if inv_radius == 0.0:
		function = func(pos):
			var location = Vector3()
			location.z = pos*10
			location.x = 0
			return basis*location + position
		drawing = DebugDraw.curve(function, Vector3(), [0, 1], Color.DARK_ORCHID, 0, false, 100)
	else:
		radius = 1/inv_radius
		function = func(pos):
			var covered_angle = pos*2*PI
			var location = Vector3()
			location.z = sin(covered_angle) * abs(radius)
			location.x = cos(covered_angle) * radius - radius
			return basis*location + position
		var max_draw = min(10/(2 * PI * abs(radius)), 1)
		drawing = DebugDraw.curve(function, Vector3(), [0, max_draw], Color.DARK_ORCHID, 0, false, 100)
	
	# Accelerate
	speed += (acceleration * push  - speed * friction - breaking * pull - abs(inv_radius*inv_min_radius)*(2 - (1 - speed/(acceleration/friction))) * turning_friction)*delta 
	speed = max(speed, 0)
	# Ground Velocity
	if inv_radius == 0:
		target_velocity.z = speed
	else:
		target_velocity.z = speed
		var covered_angle = delta*target_velocity.z/(radius)	# Find the covered angle by an object moving correctly along chord
		var t_tangent = Vector3()

		t_tangent.z = cos(covered_angle) * sin(covered_angle) * 2 * radius # By looking at the point 2 times as far along the curve we look along the tangent of the destination.
		t_tangent.x = -sin(covered_angle)**2 * 2 * radius
		var tan_curve = func(loc):
			var x_tangent = Vector3(0,0,1)
			return basis*x_tangent*loc*10 + position - Vector3(0,position.y-0.001,0)

		drawing2 = DebugDraw.curve(tan_curve, Vector3(), [0, 1], Color.DARK_ORCHID, 0, false, 100)
		look_at(basis * t_tangent + position, Vector3(0,1,0), true)	 # Set the bike to look at the tangent
		
		target_velocity.z = (sin(covered_angle) * radius)/delta		 # The distance covered, along tangent direction is 
		target_velocity.x = - radius * (1 - cos(covered_angle))/delta
		
	velocity.z = (basis*target_velocity).z
	velocity.x = (basis*target_velocity).x
	#print((basis*target_velocity).y)
	
	# Set frame visual rotation
	theta = theta_func.call(radius, speed)
	frotation = base_frame_rotation.rotated(Vector3(0,0,1), theta)
	angle = steering_angle.call(radius, theta)
	arotation = base_axel_rotation.rotated(Vector3(0,1,0), angle)
	
	frame.basis = frotation
	axel.basis = arotation
	
	move_and_slide()
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)

		# If there are duplicate collisions with a mob in a single frame
		# the mob will be deleted after the first collision, and a second call to
		# get_collider will return null, leading to a null pointer when calling
		# collision.get_collider().is_in_group("mob").
		# This block of code prevents processing duplicate collisions.
		if collision.get_collider() == null:
			continue
		# If the collider is with a mob
		if collision.get_collider().is_in_group("coin"):
			var coin = collision.get_collider()
			coin.collect()
			print('a')

			break

func _ready() -> void:
	up_direction = Vector3.UP
	floor_snap_length = 0.6
	floor_max_angle = deg_to_rad(60)
