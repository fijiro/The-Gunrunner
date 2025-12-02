extends InteractableObject
@export var product_scene: PackedScene
var product_slot: ItemSlot
var coil_slot: ItemSlot
func _ready() -> void:
	super._ready()
	inventory.ui.connect("start_press", Callable(self, "press"))
	#Render Coil and setup product_slot
	coil_slot = inventory.get_ui_slot("CoilSlot")
	coil_slot.dropped_data.connect(_coil_slot_update)
	product_slot = _get_product_slot()
	product_slot.setup(null, inventory)

func press() -> void:
	if not coil_slot.item: return
	if !product_slot.stack_size:
		var product := product_scene.instantiate()
		inventory.add_item(product, product_slot)
	else: product_slot.add_one()

func _get_product_slot() -> ItemSlot:
	return inventory.ui.get_node("FinishSlot")
	
func _coil_slot_update():
	var coil = coil_slot.item
	if !coil: return
	coil.visible = true
	coil.global_transform = $Coil_Attach.global_transform * coil.get_node("Crafting_Attach").transform.affine_inverse()
	coil.rotation = $Coil_Attach.rotation
