extends InteractableObject
var sell_slot: DraggableItem
func _ready() -> void:
	super._ready()
	inventory.ui.connect("sold_item", Callable(self, "_sell_item"))
	inventory.ui.connect("put_for_sale", Callable(self, "_update_price"))
	
	sell_slot = inventory.ui.get_node("SellSlot")
	sell_slot.setup(null, inventory)
	
func _sell_item() -> void:
	pass
func _update_price() -> void:
	# get label Price
	var label: Label = inventory.ui.get_node("Price")
	# get receiver price
	var price = (sell_slot.item as GunPart).price if sell_slot.item != null else 0
	label.text = "%s€" % price
