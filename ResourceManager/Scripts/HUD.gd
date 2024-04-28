extends CanvasLayer

@export var link : Array[Inventory]

@onready var inventory_control = $Control/InventoryControl

var is_inventory_active : bool
var current_selection : Slot

signal set_selection(slot)

func set_current_selection(slot:Slot):
	current_selection = slot
	if current_selection:
		if current_selection.item:
			set_selection.emit(current_selection)
	else:
		set_selection.emit(null)

func _input(event):
	if event.is_action_pressed("activate_inventory"):
		is_inventory_active = not is_inventory_active
		inventory_control.visible = is_inventory_active

func _on_changed_selection(inventory, index):
	change_selection(inventory, index)

func change_selection(inventory:Inventory, link_index:int):
	var selection = inventory.get_selection()
	set_current_selection(selection)
	if selection:
		link[link_index].set_selection_by_link(current_selection.get_index())
	else:
		link[link_index].set_selection_by_link(-1)
