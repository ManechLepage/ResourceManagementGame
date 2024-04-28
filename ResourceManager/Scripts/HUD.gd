extends CanvasLayer

@export var link : Array[Inventory]

@onready var inventory_control = $InventoryControl

var is_inventory_active : bool
var current_selection : Slot

signal set_selection(slot)

func set_current_selection(slot:Slot):
	current_selection = slot
	if current_selection.item:
		set_selection.emit(current_selection)

func _input(event):
	if event.is_action_pressed("activate_inventory"):
		is_inventory_active = not is_inventory_active
		inventory_control.visible = is_inventory_active

func _on_player_inventory_changed_selection(inventory:Inventory):
	set_current_selection(inventory.get_selection())
	link[0].set_selection_by_link(current_selection.get_index())

func _on_hotbar_changed_selection(inventory:Inventory):
	set_current_selection(inventory.get_selection())
	link[1].set_selection_by_link(current_selection.get_index())
