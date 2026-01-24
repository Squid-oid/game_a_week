extends PlayerState

func _ready():
	allows_control = true

func enter():
	emit_signal("anim_signal", self)
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("roll"):
		roll()
	elif Input.is_action_pressed("shoot"):
		shoot()
	else:
		pass

func roll():
	emit_signal('exit_signal', self, 'Roll')

func shoot():
	emit_signal('exit_signal', self, 'Draw')
