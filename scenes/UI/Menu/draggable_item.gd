class_name DraggableItem extends TextureRect

var item_data  # You can store custom item info here (e.g., id, type, etc.)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS

func get_drag_data(_position):
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand = true
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	set_drag_preview(preview)

	return self  # We're passing the node itself

func can_drop_data(_position, data):
	return false  # We don't drop onto this item

func drop_data(_position, data):
	# Not used here
	pass
