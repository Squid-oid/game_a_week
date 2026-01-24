extends State
signal set_velocity
var speed = 30
var direction: int
var move_timer: Timer
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	super()
	move_timer = Timer.new()
	move_timer.wait_time = 1.0
	move_timer.timeout.connect(new_move)
	add_child(move_timer)
	move_timer.stop()

func _physics_process(delta: float) -> void:
	if (player.global_position.x - %CentralHandle.global_position.x) < 75:
		emit_signal("exit_signal", self, "Follow")
		
func enter():
	new_move()
	move_timer.start()
	
func exit():
	move_timer.stop()

func new_move():
	direction = [-1,1].pick_random()
	var velocity = Vector2(direction*speed,0)
	emit_signal("set_velocity", self, velocity)
