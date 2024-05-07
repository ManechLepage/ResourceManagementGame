extends Node

var data : Dictionary
var last_delta : float = 0

func set_animation_frame(structure_type : SpriteFrames):
	if data.has(structure_type):
		return [data[structure_type], get_float_speed_of_animation(structure_type) - last_delta]
	else:
		data[structure_type] = 0
		return [0, get_float_speed_of_animation(structure_type) - last_delta]

func get_float_speed_of_animation(animation: SpriteFrames):
	return 1 / animation.get_animation_speed("default")

func _physics_process(delta):
	last_delta += delta
	for animation in data.keys():
		if last_delta > get_float_speed_of_animation(animation):
			last_delta = 0
			data[animation] += 1
			if data[animation] >= animation.get_frame_count("default"):
				data[animation] = 0
