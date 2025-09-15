extends InteractableObject
@export var weapon_scene: PackedScene
func _ready():
	super._ready()
	# Hook up workbench-specific buttons
	inventory.ui.connect("build_weapon", Callable(self, "_build_weapon"))

#TODO:
func _build_weapon() -> void:
	var parts: Dictionary = inventory.get_items()
	print(parts)
	var receiver: Receiver = parts["receiver"] if parts.has("receiver") else null
	if null in [receiver]: return
	else: print("BUILD POSSIBLE")
	receiver.position = Vector3.ZERO
	receiver.rotation = Vector3.ZERO
	var weapon: Weapon = weapon_scene.instantiate()
	if !inventory.add_item(weapon): push_error("ERROR: COULDNT ADD ITEM")
	var build_slot = (inventory.get_ui_slot(6) as ItemSlot)
	build_slot.visible = true
	build_slot.item = weapon
	for part_name in parts.keys():
		var part: GunPart = parts[part_name]
		part.visible = true
		part.reparent(weapon)
		if part_name == "receiver": continue
		var receiver_to_part = receiver.find_child("%s_Attach" % part_name.capitalize())
		var part_to_receiver = part.find_child("Receiver_Attach")
		if receiver_to_part and part_to_receiver:
			part.global_transform = receiver_to_part.global_transform * part_to_receiver.transform.affine_inverse()
		else: push_error("ERROR: NO ATTACH POINT FOUND")
		# Recalculate stats
		weapon.price += part.price + 100
		weapon.weight += part.weight
		weapon.accuracy *= part.accuracy
		weapon.ergo *= part.ergo
	print("Setting weapon rpm to ", receiver.rpm)
	weapon.rpm = receiver.rpm
	print(weapon, " RPM: ", weapon.rpm)
	#ItemSlot Based implementation?? No, better to permabuild

	weapon.position = $ReceiverPosition.position
	weapon.rotation = $ReceiverPosition.rotation
	weapon.visible = true
	for icon: ItemSlot in inventory.get_slots():
		if icon != (inventory.get_ui_slot(6) as ItemSlot):
			icon.item = null
			#icon.visible = false
		icon._regenerate_icon(true)
	#Physical item positions, todo later:
	#grip.global_position = (get_node("GripPosition") as Marker3D).global_position
	#grip.rotation = (get_node("GripPosition") as Marker3D).rotation
	#receiver.global_position = (get_node("ReceiverPosition") as Marker3D).global_position
	#receiver.rotation = (get_node("ReceiverPosition") as Marker3D).rotation
	#barrel.global_position = (get_node("BarrelPosition") as Marker3D).global_position
	#barrel.rotation = (get_node("BarrelPosition") as Marker3D).rotation
