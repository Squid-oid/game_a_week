extends PlayerState

func _ready():
	allows_control = true

func enter():
	print('Entered run')
	emit_signal('exit_signal','Idle')

func roll():
	emit_signal('exit_signal','Roll')

func shoot():
	emit_signal('exit_signal','Draw')
