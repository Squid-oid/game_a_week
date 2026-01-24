extends Enemy
class_name Box

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
func die():
	super.die()
	queue_free()
