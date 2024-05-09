extends Node2D

@export var group : String

func _ready():
	if get_tree().get_first_node_in_group(group):
		get_parent().frame = get_tree().get_first_node_in_group(group).frame
