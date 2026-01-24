extends  StateMachine
class_name PlayerStateMachine

''' A player state machine includes automatic animation setting '''
func initialize(state_name = 'Idle'):
	super(state_name)
	$AnimationSetter.set_state(current_state.name)
	return self
	
func _on_child_anim(state):
	$AnimationSetter.set_state(state.name)

''' We override the collect_states, to also feature an anim setter '''
func _collect_states(node: Node, dict):
	for child in node.get_children():
		if child is State:
			dict[child.name] = child
			child.exit_signal.connect(_on_child_transition)
			child.anim_signal.connect(_on_child_anim)
			_collect_states(child, dict)
			
