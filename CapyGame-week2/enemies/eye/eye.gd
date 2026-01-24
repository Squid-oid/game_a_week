extends Enemy
class_name Eye

# State Machine & stats machine
@onready var statemachine = $StateMachine.initialize()
@onready var prev_velocity = 0.0
# Get all attached sprite handles
@onready var handles := get_children().filter(func(subnode): return subnode is SpriteHandle)
@onready var player = get_tree().get_first_node_in_group("Player")
# Get spawn point
@onready var spawn := position
@onready var leash_distance := 120
# Set damage amount
@export var damage_amount = 10.0

func _ready() -> void:
	super()
	$StateMachine.initialize('Idle')

func _physics_process(_delta: float) -> void:
	if $StateMachine.get_state().name == 'Idle':
		leash()
	_inform_handles()
	move_and_slide()

func leash():
	if (position - spawn).length() > leash_distance:
		velocity = 30 * (spawn - position).normalized()

func die():
	super.die()
	queue_free()

''' Reports heading to handles '''
func _inform_handles():
	for handle in handles:
		if velocity.x != 0:
			handle.set_h_flip(velocity.x > 0)
	prev_velocity = velocity.x
	
func deal_damage(thing):
	thing.damage(damage_amount)
	queue_free()
