extends Area3D
signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func collect():
	collected.emit()
	queue_free()

func _on_area_entered(area: Area3D) -> void:
	print('a')
	collect()


func _on_body_entered(body: Node3D) -> void:
	print('a')
	collect()
