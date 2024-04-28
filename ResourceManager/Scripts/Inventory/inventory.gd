@tool
extends Control
class_name Inventory

@export_group("Settings")
@export var can_be_dragged : bool
@export var update : bool = false
@export_group("Grid Layout")
@export var grid_length : int
@export var slot_count : int


const STACK_SIZE : int = 100
const MARGINS : Vector2 = Vector2(10.0, 10.0)
const BASIC_SLOT = preload("res://Scenes/UI/Inventories/basic_slot.tscn")

var initial_mouse_position : Vector2
var initial_inventory_position : Vector2
var is_being_dragged : bool = false

signal inventory_changed(inventory)
signal changed_selection(inventory)

@onready var grid = $Panel/GridInventory

func _ready():
	initialize_inventory()
	inventory_changed.emit(self)

func initialize_inventory():
	for slot in grid.get_children():
		slot.queue_free()
	grid.columns = grid_length
	for i in range(slot_count):
		var slot : Control = BASIC_SLOT.instantiate()
		grid.add_child(slot)

func _on_grid_resized():
	if grid:
		size = grid.size + MARGINS
		#position = grid.position

func has_item(item:Item):
	for slot in grid.get_children():
		if slot.item == item:
			return true
	return false

func has_item_with_count(item:Item, count:int):
	var current_item_count = 0
	for slot in grid.get_children():
		if slot.item == item:
			current_item_count += slot.count
	return current_item_count >= count

func remove_item(item:Item, count:int):
	var not_removed = count
	for i in range(grid.get_child_count() - 1, -1, -1):
		var slot = grid.get_child(i)
		if slot.item == item:
			var removed = min(slot.count, not_removed)
			slot.load_new_item(slot.item, slot.count - removed)
			not_removed -= removed
			inventory_changed.emit(self)
			if slot.count == 0:
				slot.clear_slot()
		if not_removed == 0:
			break

func add_item(item:Item, count:int):
	var slot_data = get_slot_of_item(item, count)
	if slot_data:
		slot_data[0].load_new_item(item, slot_data[0].count + slot_data[1])
		inventory_changed.emit(self)

func add_item_to_slot(item:Item, count:int, slot_index:int):
	var slot = grid.get_child(slot_index)
	slot.load_new_item(item, count)

func get_slot_of_item(item:Item, count:int):
	var current_count = count
	for slot in grid.get_children():
		if slot.item == item:
			if slot.count + current_count <= STACK_SIZE:
				return [slot, current_count]
			else:
				current_count -= STACK_SIZE - slot.count
				slot.load_new_item(item, STACK_SIZE)
		elif not slot.item:
			if current_count <= STACK_SIZE:
				return [slot, current_count]
			else:
				current_count -= STACK_SIZE
				slot.load_new_item(item, STACK_SIZE)
	return null

func update_inventory():
	for slot in grid.get_children():
		if slot.count == 0:
			slot.clear_slot()

func set_selection(button:Node):
	remove_previous_selection(button)
	changed_selection.emit(self)

func set_selection_by_link(slot_index:int):
	if slot_index >= 0:
		remove_previous_selection(grid.get_child(slot_index))
	else:
		remove_all_selections()

func remove_all_selections():
	for slot in grid.get_children():
		slot.button_pressed = false

func get_selection():
	for slot in grid.get_children():
		if slot.button_pressed == true:
			return slot
	return null

func remove_previous_selection(current_button:Node):
	for slot in grid.get_children():
		if slot != current_button:
			slot.button_pressed = false
		else:
			slot.button_pressed = true

func is_mouse_in_inventory():
	var rect = get_parent().get_global_rect()
	var mouse_position = get_global_mouse_position()
	if rect.has_point(mouse_position) and not is_mouse_on_slot():
		return true
	else:
		return false

func is_mouse_on_slot():
	for slot in grid.get_children():
		if slot.get_global_rect().has_point(get_global_mouse_position()):
			return true
	return false

func _input(event):
	if event.is_action_pressed("left click"):
		if can_be_dragged:
			if is_mouse_in_inventory():
				initial_mouse_position = get_global_mouse_position()
				initial_inventory_position = get_parent().position
				is_being_dragged = true
	if event.is_action_released("left click"):
		is_being_dragged = false

func _process(delta):
	if update:
		update = false
		initialize_inventory()
	if is_being_dragged:
		get_parent().position = initial_inventory_position - (initial_mouse_position - get_global_mouse_position())

