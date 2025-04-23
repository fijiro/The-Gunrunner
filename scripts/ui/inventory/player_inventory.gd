class_name PlayerInventory extends InventoryBase

var equipped_index := -1
var equipped_item : Node3D
var money := 0
func equip_slot(index: int):
	if index < 0 or index >= 3 or !get_ui_slot(index).item: return
	if equipped_index == index:
		equipped_item.queue_free()
		equipped_index = -1
		return
	# Show selected item
	equipped_item = get_ui_slot(index).item.duplicate()
	equipped_item.visible = true
	equipped_index = index
	get_parent().get_node("Head/Hand").add_child(equipped_item)
	equipped_item.rotation = Vector3.ZERO
	equipped_item.position = Vector3.ZERO

func get_equipped_item() -> Node3D:
	if equipped_index >= 0 and equipped_index < 3:
		return equipped_item
	return null
	
func adjust_money(amount: int) -> void:
	money += amount
	ui.update_money(money)
	
