extends Enemy
class_name Boss


# Set damage level
@onready var damage_amount = 8.0

# State Machine & stats machine
@onready var statemachine = $StateMachine.initialize()
@onready var prev_velocity = 0.0
# Get all attached sprite handles
@onready var handles := get_children().filter(func(subnode): return subnode is SpriteHandle)
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	super()
	health = 120
	$StateMachine.initialize('Idle')

func _physics_process(_delta: float) -> void:
	_inform_handles()
	move_and_slide()

func die():
	super.die()
	print('You Win!')
	get_tree().quit()
	queue_free()

''' Reports heading to handles '''
func _inform_handles():
	for handle in handles:
		if velocity.x != 0:
			handle.set_h_flip(velocity.x > 0)
	prev_velocity = velocity.x

func try_damage(box, dmg = damage_amount):
	if box.get_parent().is_in_group("Player"):
		player.damage(dmg)
