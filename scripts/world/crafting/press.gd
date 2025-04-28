extends InteractableObject
@export var product_scene: PackedScene
var finish_slot: ItemSlot
var coil_slot: ItemSlot
func _ready() -> void:
	super._ready()
	inventory.ui.connect("start_press", Callable(self, "press"))
	#Render Coil and setup finish_slot
	coil_slot = inventory.get_ui_slot("CoilSlot")
	coil_slot.dropped_data.connect(_coil_slot_update)
	finish_slot = _get_finish_slot()
	finish_slot.setup(null,inventory)

func press() -> void:
	if not coil_slot.item or finish_slot.item: return
	var product := product_scene.instantiate()
	inventory.add_child(product)
	finish_slot.setup(product, inventory)

func _get_finish_slot() -> ItemSlot:
	return inventory.ui.get_node("FinishSlot")
	
func _coil_slot_update():
	var coil = coil_slot.item
	if !coil: return
	coil.visible = true
	coil.global_transform = $Coil_Attach.global_transform * coil.get_node("Crafting_Attach").transform.affine_inverse()
	coil.rotation = $Coil_Attach.rotation
