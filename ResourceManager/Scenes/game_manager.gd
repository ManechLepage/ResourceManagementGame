extends Node2D
class_name GameManager

@export var test_item : Item
@onready var player_inventory = $CanvasLayer/InventoryControl/PlayerInventory
@onready var inventory_control = $CanvasLayer/InventoryControl

var is_inventory_active : bool
var current_selection : Node

signal inventory_selection(slot_index)

func _input(event):
	if event.is_action_pressed("Test"):
		add_item_to_player_inventory(test_item, 13)
	
	if event.is_action_pressed("Test2"):
		player_inventory.remove_item(test_item, 32)
	
	if event.is_action_pressed("activate_inventory"):
		is_inventory_active = not is_inventory_active
		inventory_control.visible = is_inventory_active

func add_item_to_player_inventory(item : Item, count: int):
	player_inventory.add_item(item, count)

func set_current_selection(item:Node):
	current_selection = item
	if current_selection.item:
		inventory_selection.emit(item.get_index())
