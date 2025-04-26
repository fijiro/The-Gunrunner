extends InteractableObject
@export var case_scene: PackedScene
var finish_slot: DraggableItem
func _ready() -> void:
	super._ready()
	inventory.ui.connect("start_press", Callable(self, "press"))
	var coil_slot := inventory.get_ui_slot("CoilSlot")
	coil_slot.dropped_data.connect(_coil_slot_update.bind(coil_slot))

	finish_slot = _get_finish_slot()
	finish_slot.setup(null,inventory)
	

func press() -> void:
	if finish_slot.item != null: return
	var case := case_scene.instantiate() as Case
	finish_slot.item = case
	finish_slot.regenerate_icon()

func _get_finish_slot() -> DraggableItem:
	return inventory.ui.get_node("FinishSlot")
	
func _coil_slot_update(coil_slot: DraggableItem):
	var coil = coil_slot.item
	if !coil: return
	coil.visible = true
	coil.global_transform = $Coil_Attach.global_transform * coil.get_node("Crafting_Attach").transform.affine_inverse()
	coil.rotation = $Coil_Attach.rotation
