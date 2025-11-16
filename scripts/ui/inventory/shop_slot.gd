class_name ShopSlot extends ItemSlot

func _on_slot_pressed() -> void:
	toggle_stylebox_color()
	(inventory as ShopInventory).shop_slot_pressed(self)
	
# Disable dragging
func _get_drag_data(_at_position: Vector2) -> Variant:
	return null
