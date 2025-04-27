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
	var items: Dictionary = inventory.get_items()
	print(items)
	var product := product_scene.instantiate()
	var case: CartridgePart = items.get("case")
	if items.size() < 3: return
	else: print("BUILD POSSIBLE")
	if !inventory.add_item(product): print("ERROR: COULDNT ADD ITEM")
	product_slot.visible = true
	product_slot.item = product
	for part_name in items.keys():
		var part: CartridgePart = items[part_name]
		part.visible = true
		part.reparent(product)
		if part_name == "case": continue
		var case_to_part = case.find_child("%s_Attach" % part_name.capitalize())
		var part_to_case = part.find_child("Case_Attach")
		if case_to_part and part_to_case:
			part.global_transform = case_to_part.global_transform * part_to_case.transform.affine_inverse()
		else: print("ERROR: NO ATTACH POINT FOUND")
		# Recalculate stats
		product.price += part.price
		product.weight += part.weight
		product.accuracy *= part.accuracy
		#product.ergo *= part.ergo

func _get_product_slot() -> DraggableItem:
	return inventory.ui.get_node("ProductSlot")
	
func _part_slot_update():
	pass
