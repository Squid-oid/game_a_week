extends State
signal set_velocity
var speed = 100

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	super()

func _physics_process(_delta: float) -> void:
	var velocity = Vector2(speed*direction(), 0)
	emit_signal("set_velocity", self, velocity)

func direction():
	return sign(player.global_position.x - %CentralHandle.global_position.x)
