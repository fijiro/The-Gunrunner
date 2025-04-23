class_name PlayerUI extends CanvasLayer
var selected_slots := []
#signal pressed
#func _ready() -> void:
	#$ItemSlots/ItemSlot0.connect("pressed", _on_slot_pressed)
func set_ui_visible(enabled: bool) -> void: 
	visible = enabled
	
func update_money(money: int) -> void:
	$Money.text = "%s €" % money

#func _on_item_slot_pressed(slot_index) -> void:
	#if selected_slots.has(slot_index):
		#selected_slots.erase(slot_index)
	#else:
		#selected_slots.append(slot_index)
	#if selected_slots.size() == 2:
		##combine_items(selected_slots[0], selected_slots[1])
		#selected_slots.clear()
