extends Node2D
class_name Card

signal clicked

@export var base_scale = Vector2(1.0,1.0)
@export var hover_scale = Vector2(1.125,1.125)
@export var base_z_index = 0

var progenitor : DataCard
var hovered := false
@onready var card_play := CardPlay.new(self)

func _ready() -> void:
	z_index = base_z_index

func _process(_delta: float) -> void:
	pass
	#if hovered:
	#	$GraphicalElements.scale = hover_scale
	#		return
	#$GraphicalElements.scale = base_scale
	
func set_properties(source: DataCard):
	progenitor = source
	var data = source.data
	%ImageHolder.texture = data['image']
	%InfoText['text'] = data['desc']
	%CardName['text'] = data['name']
	if not data['cost'] == null:
		%CostBubbles.make_cost(data['cost'])

''' Input Handling '''
func _on_click_detector_pressed() -> void:
	emit_signal("clicked", self)
	
func _set_hovered():
	hovered = true
	z_index = base_z_index + 1
	$GraphicalElements.scale = hover_scale
	
func _release_hovered():
	hovered = false
	z_index = base_z_index
	$GraphicalElements.scale = base_scale

func get_card_play():
	return card_play
	
func get_gfx():
	return $GraphicalElements
