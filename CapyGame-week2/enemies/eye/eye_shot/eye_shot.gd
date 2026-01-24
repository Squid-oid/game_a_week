extends CharacterBody2D
class_name EyeShot

@onready var lifeTimer 
@export var damage_amount := 3.0

func _ready() -> void:
	lifeTimer = Timer.new()
	add_child(lifeTimer)
	lifeTimer.wait_time = 12
	lifeTimer.connect("timeout", delete)
	lifeTimer.start()
	
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func delete():
	queue_free()

func hurt(player):
	player.damage(damage_amount)
	queue_free()
