extends InteractableObject
@export var product_scene: PackedScene
var product_slot: ItemSlot
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
	var items: Dictionary = inventory.get_items()
	print(items)
	var product: Cartridge = product_scene.instantiate()
	var case: Cartridge = items.get("case")
	if items.size() < 3: return
	else: print("ASSEMBLY POSSIBLE")
	if !inventory.add_item(product, product_slot): print("ERROR: COULDNT ADD ITEM")
	product_slot.visible = true
	var part: Cartridge
	for part_name in items.keys():
		part = items.get(part_name).duplicate()
		part.visible = true
		if part.get_parent(): part.reparent(product)
		else: product.add_child(part)
		if part_name == "case": continue
		var case_to_part: Marker3D = case.find_child("%s_Attach" % part_name.capitalize())
		var part_to_case: Marker3D = part.find_child("Case_Attach")
		if case_to_part and part_to_case:
			part.global_transform = case_to_part.global_transform * part_to_case.transform.affine_inverse()
			part.rotation = case_to_part.rotation
		else: print("ERROR: NO ATTACH POINT FOUND")
		# Recalculate stats
		product.price += part.price
		product.weight += part.weight
		product.accuracy *= part.accuracy
		
	product.position = $ProductPosition.position
	product.rotation = $ProductPosition.rotation
	product.visible = true
	#Remove one after assembly
	for slot: ItemSlot in inventory.get_slots():
		if slot != product_slot: slot.take_one()
	product_slot._regenerate_icon(true)
	
func _get_product_slot() -> ItemSlot:
	return inventory.ui.get_node("ProductSlot")
	
func _part_slot_update():
	pass
