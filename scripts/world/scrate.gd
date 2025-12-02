class_name ShipmentCrate extends InteractableObject

func _ready():
	super._ready()
	for slot: ItemSlot in inventory.get_slots():
		slot.connect("dropped_data", _check_if_empty)
		slot.remove_only = true

# auto delete crate when empty
func _check_if_empty() -> void:
	if inventory.get_items().is_empty():
		await exit_menu()
		queue_free()
