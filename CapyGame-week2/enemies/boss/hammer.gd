extends State
signal set_velocity
var speed = 30
var direction: int
var attack_timer: Timer
var reset_timer: Timer
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	super()
	attack_timer = Timer.new()
	attack_timer.wait_time = (5.0/8.0)
	attack_timer.timeout.connect(hit)
	add_child(attack_timer)
	attack_timer.stop()
	
	reset_timer = Timer.new()
	reset_timer.wait_time = (1.0/8.0)
	reset_timer.timeout.connect(reset)
	add_child(reset_timer)
	reset_timer.stop()

		
func enter():
	var velocity = Vector2(0,0)
	emit_signal("set_velocity", self, velocity)
	attack_timer.start()
	%AnimationTree["parameters/playback"].travel('hammer')
	
func exit():
	attack_timer.stop()

func hit():
	%Hammer.disabled = false
	reset_timer.start()
	
func reset():
	reset_timer.stop()
	%Hammer.disabled = true
	emit_signal("exit_signal", self, ["Idle", "Idle", "Hammer", "Thrust"].pick_random())
