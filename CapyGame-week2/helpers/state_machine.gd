extends Node
class_name  StateMachine

var states : Dictionary = {}
var current_state: State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_collect_states(self, states)
	
func initialize(state_name = 'Idle'):
	current_state = states[state_name]
	current_state.enter()
	return self
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _collect_states(node: Node, dict):
	for child in node.get_children():
		if child is State:
			dict[child.name] = child
			child.exit_signal.connect(_on_child_transition)
			_collect_states(child, dict)

func _on_child_transition(state, new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name)
	
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	new_state.enter()
	
func get_state():
	return current_state
