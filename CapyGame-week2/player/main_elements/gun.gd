extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$gun_sprite.play("nothing")

func shoot():
	$AnimationTree['parameters/playback'].travel('pew')
	if $Hurtbox.is_colliding():
		var first_hit = $Hurtbox.get_collider()
		if first_hit.is_in_group('hurtable'):
			first_hit.shot()

func on_handle_flip():
	$Hurtbox.target_position.y = -$Hurtbox.target_position.y 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
