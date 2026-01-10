extends CollisionShape3D
@onready var frame = get_node('../Frame/Axel_Rotator/Align/Axel/FTire')
@onready var offset = frame.global_transform.inverse() * global_transform
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(frame) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	# Apply offset every frame
	global_transform = frame.global_transform * offset
