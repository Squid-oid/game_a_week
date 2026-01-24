extends PlayerState
@onready var shot_timer := Timer.new()

func _ready():
	''' Create Shot Timer '''
	shot_timer.wait_time = (8.0/12.0)
	add_child(shot_timer)
	shot_timer.connect("timeout", fire)
	allows_control = true

func enter():
	emit_signal("anim_signal", self)
	shot_timer.start()

func exit():
	shot_timer.stop()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("roll"):
		roll()
	elif Input.is_action_pressed("shoot"):
		shoot()
	else:
		idle()

func roll():
	emit_signal('exit_signal',self,'Roll')

func fire():
	%Gun.shoot()

func idle():
	emit_signal('exit_signal',self,'Idle')
