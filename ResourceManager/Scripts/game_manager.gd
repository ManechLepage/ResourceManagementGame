extends Node2D
class_name GameManager

@export var test_item : Item
@onready var player_inventory = $CanvasLayer/InventoryControl/PlayerInventory
@onready var tile_map = %TileMap

var is_player_building : bool = false
var current_selection : Slot

func _input(event):
	if event.is_action_pressed("Test"):
		add_item_to_player_inventory(test_item, 13)
	
	if event.is_action_pressed("Test2"):
		player_inventory.remove_item(test_item, 32)
	
	if event.is_action_pressed("left click"):
		if is_player_building:
			place_structure()

func add_item_to_player_inventory(item : Item, count: int):
	player_inventory.add_item(item, count)

func start_building():
	is_player_building = true
	tile_map.start_previewing_structure(current_selection.item.structure_scene)

func end_building():
	is_player_building = false
	tile_map.end_previewing_structure()

func _on_set_selection(slot:Slot):
	var item : Item = slot.item
	current_selection = slot
	if item is StructureItem:
		start_building()
	else:
		end_building()

func place_structure():
	tile_map.place_structure(current_selection.item.structure_scene)
