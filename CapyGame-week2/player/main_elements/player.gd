class_name CapyPlayer 
extends CharacterBody2D

# Movement parameters
@onready var  speed := 120.0
const JUMP_VELOCITY := -40.0

# Health
@onready var health = 20.0
@onready var alive = true

# Direction
@onready var direction = 0 # 0 static, -1 left, 1 right (for roll speed boost)

# State Machine & stats machine
@onready var statemachine = $StateMachine.initialize()

# Get all attached sprite handles
@onready var handles := get_children().filter(func(subnode): return subnode is SpriteHandle)


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	_try_set_direction(Input.get_axis("left","right"))
	velocity.x = direction * speed
	_inform_animation_tree()
	_inform_handles()
	move_and_slide()

func _process(_delta:float) -> void:
	pass


''' Damage and Healing '''
func damage(amount):
	if alive:
		health = clamp(health - amount, 0.0 ,20)
		print("Post Damage Health is: " + str(health))
		if health <= 0.0:
			die()

func full_heal():
	health = 20

func heal(amount):
	damage(-amount)

func die():
	alive = false
	print('You Lose!')
	get_tree().quit()
	queue_free()

''' Attempts to set velocity '''
func _try_set_direction(new_direction):
	if get_state().allows_control:
		direction = new_direction

''' Emits signals reporting state changes '''
func _send_signals():
	pass
	
''' Reports heading to handles '''
func _inform_handles():
	for handle in handles:
		if Input.get_axis("left","right") != 0:
			handle.set_h_flip(velocity.x < 0)

''' Updates the animation tree with new blend positions '''
func _inform_animation_tree():
	var moving = int(abs(velocity.x) > 0.001)
	%BodyAnimationTree.set('parameters/Moving/blend_amount', moving) # Set Blend Position of Switch between moving vs static animation set
	
''' Gets the current state from the state machine '''
func get_state():
	return statemachine.get_state()
