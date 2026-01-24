extends Node
@onready var static_state = %BodyAnimationTree["parameters/StaticState/playback"]
@onready var moving_state = %BodyAnimationTree["parameters/MovingState/playback"]


func set_state(state_name):
	static_state.travel(state_name)
	moving_state.travel(state_name)
