extends Node
class_name Transitioner

var fade_out: Timer
var fade_in: Timer
var next_scene: String

func _ready() -> void:
	fade_out = Timer.new()
	fade_out.timeout.connect(_swap_scene)
	fade_out.wait_time = 1.0
	fade_out.one_shot = true
	add_child(fade_out)

	fade_in = Timer.new()
	fade_in.timeout.connect(_finished)
	fade_in.wait_time = 1.0
	fade_in.one_shot = true
	add_child(fade_in)
	
	$Background['color'] = Color(0,0,0,0)
	
func on_transition(scene := 'main_menu'):
	next_scene = scene
	$AnimationPlayer.play("Fade Out")
	fade_out.start()
	
func _swap_scene():
	$AnimationPlayer.play("Fade In")
	var path = 'res://' + next_scene
	
	if ResourceLoader.exists(path):
		var tree = get_parent().get_tree()
		self.reparent(tree.root)
		tree.change_scene_to_file(path)		
	else:
		push_warning("No Valid Next Scene Found at path: " + path + "|| In transitioner")
	
func _finished():
	queue_free()
