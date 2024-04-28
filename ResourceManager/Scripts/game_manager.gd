extends Node2D
class_name GameManager

@export var test_item : Item
@onready var player_inventory = $CanvasLayer/Control/InventoryControl/PlayerInventory
@onready var tile_map = %TileMap
@onready var canvas_layer = %CanvasLayer

var is_player_building : bool = false
var current_selection : Slot

var is_building : bool = false
var is_deleting : bool = false

func _input(event):
	if event.is_action_pressed("Test"):
		add_item_to_player_inventory(test_item, 13)
	
	if event.is_action_pressed("Test2"):
		player_inventory.remove_item(test_item, 32)
	
	if event.is_action_pressed("left click"):
		if is_player_building:
			is_building = true
	
	if event.is_action_released("left click"):
		is_building = false
	
	if event.is_action_pressed("right click"):
		is_deleting = true
	
	if event.is_action_released("right click"):
		is_deleting = false

func add_item_to_player_inventory(item : Item, count: int):
	player_inventory.add_item(item, count)

func start_building():
	is_player_building = true
	tile_map.start_previewing_structure(current_selection.item.structure_scene)

func end_building():
	is_player_building = false
	tile_map.end_previewing_structure()

func _on_set_selection(slot:Slot):
	if slot:
		var item : Item = slot.item
		current_selection = slot
		if item is StructureItem:
			start_building()
		else:
			end_building()
	else:
		current_selection = null
		end_building()

func place_structure():
	if not is_click_in_ui():
		if tile_map.can_place_structure():
			tile_map.place_structure(current_selection.item.structure_scene)

func remove_structure():
	if not is_click_in_ui():
		if not tile_map.can_place_structure(): # change later when other criteria for placing structure
			tile_map.remove_structure()

func _process(delta):
	if is_building:
		place_structure()
	if is_deleting:
		remove_structure()

func is_click_in_ui():
	for control in canvas_layer.get_child(0).get_children():
		if Rect2(Vector2.ZERO, control.size).has_point(get_global_mouse_position()):
			return true
	return false
