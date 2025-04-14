extends CanvasLayer
var selected_slots := []
signal pressed
#func _ready() -> void:
	#$GridContainer/ItemSlot0.connect("pressed", _on_slot_pressed)
func set_ui_visible(enabled: bool): 
	visible = enabled
	
func _on_item_slot_pressed(slot_index):
	if selected_slots.has(slot_index):
		selected_slots.erase(slot_index)
	else:
		selected_slots.append(slot_index)
	if selected_slots.size() == 2:
		#combine_items(selected_slots[0], selected_slots[1])
		selected_slots.clear()
func _on_slot_pressed(index):
	var item_slot = get_node("GridContainer/ItemSlot%s" % index)
	item_slot.queue_free()
