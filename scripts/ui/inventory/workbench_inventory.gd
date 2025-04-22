class_name WorkbenchInventory extends InventoryBase
# TODO:
# 1. Make item slots for grip, receiver and barrel that only accept that type
#	(1.1 Slots show 3D items on marker slots)
# 2. After all slots have an item, build button is visible
# 3. Pressing build button:
# 	3.1 Combines all parts under receiver
# 	3.2 Moves new item to FinishedItem
#	3.3 Clears old item slots
#	(3.4 Show 3D model on workbench)
func get_parts() -> Dictionary[String, Node3D]:
	var parts: Dictionary[String, Node3D] = {}
	for slot in get_slots():
		if slot.item != null: parts.set((slot.item as GunPart).type, slot.item)
	return parts
