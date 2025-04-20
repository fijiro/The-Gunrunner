extends InteractableObject

func _ready():
	super._ready()
	# Hook up close callback and buttons
	inventory.ui.connect("menu_closed", Callable(self, "exit_menu"))
	inventory.ui.connect("build_weapon", Callable(self, "_build_weapon"))

#TODO:
func _build_weapon():
	var grip = (inventory.get_ui_slot(0) as DraggableItem).item
	var receiver = (inventory.get_ui_slot(1) as DraggableItem).item
	var barrel = (inventory.get_ui_slot(2) as DraggableItem).item
	if null in [grip, receiver, barrel]: return
	else: print("OMG BUILD POSSIBLE HOLY SHIT")
	grip.visible = true
	grip.global_position = (get_node("GripPosition") as Marker3D).global_position
	grip.rotation = (get_node("GripPosition") as Marker3D).rotation
	receiver.visible = true
	receiver.global_position = (get_node("ReceiverPosition") as Marker3D).global_position
	receiver.rotation = (get_node("ReceiverPosition") as Marker3D).rotation
	barrel.visible = true
	barrel.global_position = (get_node("BarrelPosition") as Marker3D).global_position
	barrel.rotation = (get_node("BarrelPosition") as Marker3D).rotation
	grip.reparent(receiver, false)
	barrel.reparent(receiver, false)
	# Calculate correct positions for part
	var barrel_to_receiver = barrel.find_child("Receiver_Attach")
	var receiver_to_barrel = receiver.find_child("Barrel_Attach")
	barrel.global_transform = receiver_to_barrel.global_transform * barrel_to_receiver.transform.affine_inverse()
	var grip_to_receiver = grip.find_child("Receiver_Attach")
	var receiver_to_grip = receiver.find_child("Grip_Attach")
	grip.global_transform = receiver_to_grip.global_transform * grip_to_receiver.transform.affine_inverse()
	# Recalculate stats
	#ItemSlot Based implementation
	var build_slot = (inventory.get_ui_slot(5) as DraggableItem)
	build_slot.visible = true
	(inventory.get_ui_slot(5) as DraggableItem).item = receiver	
	receiver.position = Vector3(0,0,0)
	receiver.rotation = rotation
	(inventory.get_ui_slot(5) as DraggableItem).regenerate_icon(true)
	(inventory.get_ui_slot(0) as DraggableItem).item = null
	(inventory.get_ui_slot(0) as DraggableItem).regenerate_icon()
	(inventory.get_ui_slot(1) as DraggableItem).item = null
	(inventory.get_ui_slot(1) as DraggableItem).regenerate_icon()
	(inventory.get_ui_slot(2) as DraggableItem).item = null
	(inventory.get_ui_slot(2) as DraggableItem).regenerate_icon()
