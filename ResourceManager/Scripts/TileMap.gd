extends TileMap

@onready var structures = %Structures

var current_selected_structure : PackedScene = null
var preview_structure : Structure

func place_structure(structure:PackedScene):
	var structure_scene : Structure= structure.instantiate()
	structure_scene.grid_position = set_tile_position_of_structure(get_global_mouse_position())
	structure_scene.position = set_global_position_of_structure(structure_scene.grid_position)
	structures.add_child(structure_scene)

func set_global_position_of_structure(structure_grid_position:Vector2i):
	var tile_size = tile_set.tile_size
	return Vector2(structure_grid_position.x + 0.5, structure_grid_position.y + 0.5) * Vector2(tile_size)

func set_tile_position_of_structure(global_position_of_structure:Vector2):
	return  Vector2i(local_to_map(to_local(global_position_of_structure)))

func start_previewing_structure(structure:PackedScene):
	remove_all_preview_structures()
	current_selected_structure = structure
	preview_structure = current_selected_structure.instantiate()
	preview_structure.set_structure_to_preview()
	structures.add_child(preview_structure)

func end_previewing_structure():
	current_selected_structure = null
	preview_structure.queue_free()

func _process(delta):
	if current_selected_structure:
		move_preview_structure()

func move_preview_structure():
	preview_structure.grid_position = set_tile_position_of_structure(get_global_mouse_position())
	preview_structure.position = set_global_position_of_structure(preview_structure.grid_position)

func remove_all_preview_structures():
	for structure in structures.get_children():
		if structure.is_preview:
			structure.queue_free()
