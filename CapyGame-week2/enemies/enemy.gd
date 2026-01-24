extends CharacterBody2D
class_name Enemy

var health : float = 40
var flash_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('hurtable')
	flash_timer.wait_time = (12.0/60.0)
	flash_timer.connect("timeout", reset_color)
	add_child(flash_timer)

func shot(dmg = 10.0):
	hurt(dmg)
	

func hurt(dmg = 10.0):
	health -= dmg
	print(self.name + ', health: ' + str(health))
	_flash()
	if health <= 0:
		die()
		
func die():
	print(self.name + " died!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _flash(modul = Color(1,0.5,0.5,1)):
	modulate = modul
	flash_timer.start()
	
func reset_color():
	modulate = Color(1,1,1,1)
	flash_timer.stop()
