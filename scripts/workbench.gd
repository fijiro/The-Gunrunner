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
	var grip: Node3D = parts["grip"] if parts.has("grip") else null
	var receiver: Node3D = parts["receiver"] if parts.has("receiver") else null
	var barrel: Node3D = parts["barrel"] if parts.has("barrel") else null
	var stock: Node3D = parts["stock"] if parts.has("stock") else null
	if null in [grip, receiver, barrel]: return
	#else: print("BUILD POSSIBLE")
	grip.visible = true
	receiver.visible = true
	barrel.visible = true
	stock.visible = true
	grip.reparent(receiver, false)
	barrel.reparent(receiver, false)
	stock.reparent(receiver, false)
	# Calculate correct positions for part
	var barrel_to_receiver = barrel.find_child("Receiver_Attach")
	var receiver_to_barrel = receiver.find_child("Barrel_Attach")
	barrel.global_transform = receiver_to_barrel.global_transform * barrel_to_receiver.transform.affine_inverse()
	var grip_to_receiver = grip.find_child("Receiver_Attach")
	var receiver_to_grip = receiver.find_child("Grip_Attach")
	grip.global_transform = receiver_to_grip.global_transform * grip_to_receiver.transform.affine_inverse()
	var stock_to_receiver = stock.find_child("Receiver_Attach")
	var receiver_to_stock = receiver.find_child("Stock_Attach")
	stock.global_transform = receiver_to_stock.global_transform * stock_to_receiver.transform.affine_inverse()

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
		icon.regenerate_icon(true)
	#Physical item positions, todo
	#grip.global_position = (get_node("GripPosition") as Marker3D).global_position
	#grip.rotation = (get_node("GripPosition") as Marker3D).rotation
	#receiver.global_position = (get_node("ReceiverPosition") as Marker3D).global_position
	#receiver.rotation = (get_node("ReceiverPosition") as Marker3D).rotation
	#barrel.global_position = (get_node("BarrelPosition") as Marker3D).global_position
	#barrel.rotation = (get_node("BarrelPosition") as Marker3D).rotation
