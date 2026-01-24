extends StateMachine

var attached_enemy: CharacterBody2D

func _ready() -> void:
	super()
	var parent = get_parent()
	if parent is CharacterBody2D:
		self.attached_enemy = parent
		print('attached')

func _collect_states(node: Node, dict):
	for child in node.get_children():
		if child is State:
			dict[child.name] = child
			child.exit_signal.connect(_on_child_transition)
			child.set_velocity.connect(_set_velocity)
			_collect_states(child, dict)

func _set_velocity(state, vel):
	if state != current_state:
		return
	attached_enemy.set_velocity(vel)

func override_attach(enemy):
	self.attached_enemy = enemy
