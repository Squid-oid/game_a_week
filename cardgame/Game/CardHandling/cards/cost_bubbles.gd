extends Node2D
var cost = 0

func make_cost(num: int):
	cost = num

func _draw():
	for i in cost:
		draw_circle(Vector2(i*2,0.0), 0.8, Color(1,0.3,0.3,0.8))
