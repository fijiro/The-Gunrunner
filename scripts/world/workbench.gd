extends InteractableObject
func _ready():
	super._ready()
	# Hook up close callback and buttons
	inventory.ui.connect("menu_closed", Callable(self, "exit_menu"))
	inventory.ui.connect("build_weapon", Callable(self, "_build_weapon"))

#TODO:
func _build_weapon():
	var parts: Dictionary = (inventory as WorkbenchInventory).get_parts()
	print(parts)
	var receiver: GunPart = parts["receiver"] if parts.has("receiver") else null
	if null in [receiver]: return
	else: print("BUILD POSSIBLE")
	for part_name in parts.keys():
		var part: GunPart = parts[part_name]
		part.visible = true
		if part_name == "receiver": continue
		part.reparent(receiver)
		
		var receiver_to_part = receiver.find_child("%s_Attach" % part_name.capitalize())
		var part_to_receiver = part.find_child("Receiver_Attach")
		if receiver_to_part and part_to_receiver:
			part.global_transform = receiver_to_part.global_transform * part_to_receiver.transform.affine_inverse()

	# Recalculate stats
	#ItemSlot Based implementation
	var build_slot = (inventory.get_ui_slot(5) as DraggableItem)
	build_slot.visible = true
	(inventory.get_ui_slot(5) as DraggableItem).item = receiver
	receiver.position = Vector3(0,0,0)
	receiver.rotation = rotation
	for icon: DraggableItem in inventory.get_slots():
		if icon != (inventory.get_ui_slot(5) as DraggableItem):
			icon.item = null
			icon.visible = false
		else: icon.regenerate_icon(true)
	#Physical item positions, todo:
	#grip.global_position = (get_node("GripPosition") as Marker3D).global_position
	#grip.rotation = (get_node("GripPosition") as Marker3D).rotation
	#receiver.global_position = (get_node("ReceiverPosition") as Marker3D).global_position
	#receiver.rotation = (get_node("ReceiverPosition") as Marker3D).rotation
	#barrel.global_position = (get_node("BarrelPosition") as Marker3D).global_position
	#barrel.rotation = (get_node("BarrelPosition") as Marker3D).rotation
