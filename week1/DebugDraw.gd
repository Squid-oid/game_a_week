extends Node

# Create an arbitary curve drawing
func curve(function: Callable, root: Vector3, interval = [0,1], color = Color.PURPLE, point_color = Color.DARK_ORANGE, draw_points = true, num_points = 12) -> MeshInstance3D:
	var dcurve := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	dcurve.mesh = immediate_mesh
	dcurve.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	for n in range(num_points):
		var pos = interval[0] + (n*interval[1]*0.9999)/(num_points-1)
		var location = root + function.call(pos)
		immediate_mesh.surface_add_vertex(location)
		if draw_points:
			pass
			#points.append(point(location, 0.05, point_color))
			#print('Drawing at' + str(location))
	immediate_mesh.surface_end()
	
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child(dcurve)
	return dcurve
# Create a line between two points
func line(pos0: Vector3, pos1: Vector3, color = Color.PURPLE) -> MeshInstance3D:
	var dline := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	dline.mesh = immediate_mesh
	dline.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos0)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
		
	get_tree().get_root().add_child(dline)
	return dline

# Create and return a point as a child of the root
@onready var dpoint := MeshInstance3D.new()
func _ready() -> void:
	var dpoint := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()
	
	dpoint.mesh = mesh
	dpoint.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	mesh.radius =  0.05
	mesh.height =  0.05*2
	mesh.material = material
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.DARK_ORANGE
	
func point(pos:Vector3, radius = 0.05, color = Color.PURPLE) -> MeshInstance3D:
	dpoint.position = pos
	get_tree().get_root().add_child(dpoint)
	return dpoint
