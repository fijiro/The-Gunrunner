class_name PlayerInventory extends InventoryBase

var equipped_index := -1
var money := 0
func equip_item(index: int):
	if index < 0 or index >= items.size():
		print("Invalid item index")
		return

	# Hide all items
	for item in items:
		item.visible = false

	# Show selected item
	var selected_item = items[index]
	selected_item.visible = true
	equipped_index = index
	get_parent().get_node("Hand").add_child(selected_item)

func get_equipped_item() -> Node3D:
	if equipped_index >= 0 and equipped_index < items.size():
		return items[equipped_index]
	return null
	
func adjust_money(amount: int) -> void:
	money += amount
	ui.update_money(money)
	
