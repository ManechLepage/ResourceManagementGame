extends Node


@export var slot_index_linked : Vector2i

func _on_player_inventory_changed(player_inventory):
	for slot in player_inventory.grid.get_children():
		var slot_index = slot.get_index()
		if slot.item:
			if slot_index >= slot_index_linked.x and slot_index <= slot_index_linked.y:
				get_parent().add_item_to_slot(slot.item, slot.count, slot_index)
				get_parent().update_inventory()
