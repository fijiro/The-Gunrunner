extends InteractableObject
@export var product_scene: PackedScene
var product_slot: DraggableItem
func _ready() -> void:
	super._ready()
	inventory.ui.connect("start_assembly", Callable(self, "assemble"))
	#Render Coil and setup product_slot
	product_slot = _get_product_slot()
	product_slot.setup(null,inventory)

func assemble() -> void:
	#TODO:
	if null in inventory.get_slots():
		return
	var product := product_scene.instantiate()
	inventory.add_child(product)
	product_slot.setup(product, inventory)
	var parts: Dictionary = inventory.get_part
	print(parts)
	var weapon: GunPart = weapon_scene.instantiate()
	var receiver: GunPart = parts["receiver"] if parts.has("receiver") else null
	var build_slot = (inventory.get_ui_slot(6) as DraggableItem)
	if null in [receiver]: return
	else: print("BUILD POSSIBLE")
	if !inventory.add_item(weapon): print("ERROR: COULDNT ADD ITEM")
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
		else: print("ERROR: NO ATTACH POINT FOUND")
		# Recalculate stats
		weapon.price += part.price
		weapon.weight += part.weight
		weapon.accuracy *= part.accuracy
		weapon.ergo *= part.ergo

func _get_product_slot() -> DraggableItem:
	return inventory.ui.get_node("ProductSlot")
	
func _part_slot_update():
	pass
