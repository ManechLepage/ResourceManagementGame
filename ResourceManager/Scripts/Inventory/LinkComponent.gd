extends Node

@onready var player_inventory = $".."
@onready var grid_inventory = $"../Panel/GridInventory"

func _ready():
	get_tree().root.get_chlid(0).inventory_selection.connect(selection_update.bind())

func selection_update(slot_index):
	player_inventory.set_selection(grid_inventory.get_child(slot_index))
