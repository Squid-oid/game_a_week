extends PlayerState
signal rolling

@export var player: Node2D
@onready var roll_timer = Timer.new()
const SPD_SHIFT = 40

func _ready():
	allows_control = false
	
	''' Create Roll Timer '''
	roll_timer.wait_time = (8.0/12.0)
	add_child(roll_timer)
	roll_timer.connect("timeout", done_rolling)

func enter():
	emit_signal("anim_signal", self)
	emit_signal('rolling', true)
	player.speed += SPD_SHIFT
	roll_timer.start()
	
func exit():
	emit_signal('rolling', false)
	player.speed -= SPD_SHIFT
	roll_timer.stop()

func roll():
	pass

func shoot():
	pass

func done_rolling():
	emit_signal('exit_signal', self, 'Idle')
