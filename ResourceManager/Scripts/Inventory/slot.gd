extends TextureButton

@onready var texture_rect = $TextureRect
@onready var label = $Label

var item : Item = null
var count : int = 0

func _ready():
	clear_slot()

func load_new_item(_item : Item, _count : int):
	item = _item
	count = _count
	
	label.text = str(count)
	texture_rect.texture = item.icon

func clear_slot():
	label.text = ""
	texture_rect.texture = null
	
	count = 0
	item = null

func _on_toggled(toggled_on):
	if toggled_on:
		get_parent().get_parent().get_parent().set_selection(self)
