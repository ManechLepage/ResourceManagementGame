extends Path2D

@export var completion_time : float
@export var hide_items : bool

func _on_item_added_to_inventory(item):
	var path_follow = PathFollow2D.new()
	add_child(path_follow)
