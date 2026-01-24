extends Node2D
class_name SpriteHandle
'''
A sprite_handle, this let's us mirror sprites around a shifted origin, so we can pin them relative to an outside object.
Add the sprite as a child to this, transform only the sprite handle not the sprite. Connect a signal to _flip_h() or 
_set_h_flip to programatically flip. Additionaly emits a signal on turn.
'''

@onready var _init_pos := position
@onready var _h_flip := false
@onready var _sprites := []
@onready var _orientation_changed := false
signal turned

# On ready find all of the sprites that are eventually pinned to this handle
func _ready() -> void:
	_find_sprites(self, _sprites)

# Sets the hflip of each child sprite, and the position of the sprite handle 
func _process(_delta: float) -> void:
	if not _orientation_changed:
		return
		
	position.x = _init_pos.x if not _h_flip else -_init_pos.x
	for sprite in _sprites:
		sprite.flip_h = _h_flip
		
	_orientation_changed = false

# Recursive search for sprites, runs once.
func _find_sprites(node, list):
	for subnode in node.get_children():
		if subnode is Sprite2D or subnode is AnimatedSprite2D:
			list.append(subnode)
		_find_sprites(subnode, list)

# Sets wether to flip this sprite handle
func set_h_flip(flip):
	if flip != _h_flip:
		_orientation_changed = true
		emit_signal("turned")
	_h_flip = flip

# Inverses flip state
func flip_h():
	_h_flip = not _h_flip
	emit_signal("turned")
	_orientation_changed = true
