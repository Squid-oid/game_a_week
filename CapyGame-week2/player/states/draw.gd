extends PlayerState

@onready var draw_timer := Timer.new()
@onready var cool_down_timer := Timer.new()
@onready var on_cool_down = false


func _ready():
	allows_control = true
	
	''' Create Draw Timer '''
	draw_timer.wait_time = (3.0/24.0)
	add_child(draw_timer)
	draw_timer.connect("timeout", done_drawing)
	
	''' Add Cooldown to Stop Repeated Drawing from OutDPSing shooting and for animations '''
	cool_down_timer.wait_time = (8.0/24.0)
	add_child(cool_down_timer)
	cool_down_timer.connect("timeout", _clear_cooldown)

func enter():
	if on_cool_down:
		emit_signal('exit_signal', self, 'Idle')	# Return to idle
		return
	emit_signal("anim_signal", self)
	draw_timer.start()
	cool_down_timer.start()
	on_cool_down = true
	
func exit():
	pass
	
func done_drawing():
	draw_timer.stop()
	%Gun.shoot()
	if Input.is_action_pressed("roll"):
		emit_signal('exit_signal', self, 'Roll')
	elif Input.is_action_pressed("shoot"):
		emit_signal('exit_signal', self, 'Shoot')
	else:
		emit_signal('exit_signal', self, 'Idle')
	
func _clear_cooldown():
	cool_down_timer.stop()
	on_cool_down = false

func check_cooldown():
	return on_cool_down
