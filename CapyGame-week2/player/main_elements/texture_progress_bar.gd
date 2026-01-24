extends TextureProgressBar

@export var character: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if character:
		value = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = character.health
