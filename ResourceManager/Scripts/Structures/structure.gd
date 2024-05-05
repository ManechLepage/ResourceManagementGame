extends AnimatedSprite2D
class_name Structure

@export var preview_shader : ShaderMaterial
@export var preview_shader_incorrect_position : ShaderMaterial

var grid_position:Vector2i
var is_preview:bool = false
var can_place:bool = true

func _ready():
	play()

func set_structure_to_preview():
	material = preview_shader
	is_preview = true
	z_index = 1

func set_structure_shader_to_incorrect():
	can_place = false
	material = preview_shader_incorrect_position

func set_structure_shader_to_correct():
	can_place = true
	material = preview_shader
