extends Sprite2D
class_name Structure

@export var preview_shader:ShaderMaterial

var grid_position : Vector2i
var is_preview : bool = false

func set_structure_to_preview():
	material = preview_shader
	is_preview = true
