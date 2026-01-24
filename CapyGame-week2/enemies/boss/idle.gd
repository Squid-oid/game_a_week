extends State
signal set_velocity
var speed = 120
var direction: int
var move_timer: Timer
var refa_timer: Timer
var ready_to_attack: bool
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	super()
	move_timer = Timer.new()
	move_timer.wait_time = 1.0
	move_timer.timeout.connect(new_move)
	add_child(move_timer)
	move_timer.stop()
	
	refa_timer = Timer.new()
	refa_timer.wait_time = 1.2
	refa_timer.timeout.connect(ready_att)
	add_child(refa_timer)
	refa_timer.stop()

func _physics_process(_delta: float) -> void:		
	if abs(player.global_position.x - %CentralHandle.global_position.x) < 400 &&  abs(player.global_position.x - %CentralHandle.global_position.x) > 60:
		move_timer.stop()
		var velocity = Vector2(sign(player.global_position.x - %CentralHandle.global_position.x)*speed,0)
		emit_signal("set_velocity", self, velocity)
		
	elif abs(player.global_position.x - %CentralHandle.global_position.x) < 50:
		move_timer.stop()
		var velocity = Vector2(-sign(player.global_position.x - %CentralHandle.global_position.x)*speed,0)
		emit_signal("set_velocity", self, velocity)
	
	elif abs(player.global_position.x - %CentralHandle.global_position.x) < 60 && ready_to_attack:
		emit_signal('exit_signal', self, ['Hammer','Thrust','Stomp'].pick_random())	
	
	else:
		pass

		
func ready_att():
	refa_timer.stop()
	ready_to_attack = true

func enter():
	new_move()
	move_timer.start()
	refa_timer.start()
	%AnimationTree["parameters/playback"].travel('walk')
	ready_to_attack = false
	
func exit():
	move_timer.stop()

func new_move():
	direction = [-1,1].pick_random()
	var velocity = Vector2(direction*speed,0)
	emit_signal("set_velocity", self, velocity)
