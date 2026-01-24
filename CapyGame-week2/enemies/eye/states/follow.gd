extends State
signal set_velocity
var speed = 30
var ram_timer: Timer
var shot_timer: Timer

@onready var player = get_tree().get_first_node_in_group("Player")
@export var bullet: PackedScene

func _ready():
	super()
	ram_timer = Timer.new()
	ram_timer.timeout.connect(ram)
	add_child(ram_timer)
	
	shot_timer = Timer.new()
	shot_timer.timeout.connect(shoot)
	add_child(shot_timer)
	shot_timer.wait_time = 1

func _physics_process(_delta: float) -> void:
	if (player.global_position.x - %CentralHandle.global_position.x) > 100:
		emit_signal('exit_signal', self, 'Idle')
		return
	var velocity = Vector2(speed*direction(), 0)
	emit_signal("set_velocity", self, velocity)
	
func ram():
	emit_signal("exit_signal", self, 'Ram')

func enter():
	ram_timer.wait_time = 4.0 + 3*randf()
	#ram_timer.start()
	shot_timer.start()
	
func exit():
	ram_timer.stop()
	shot_timer.stop()

func direction():
	return sign(player.global_position.x - %CentralHandle.global_position.x)
	
func shoot():
	var bull = bullet.instantiate()
	bull.velocity.x = direction()*250
	bull.global_position = %CentralHandle.global_position
	get_tree().get_root().add_child(bull)
