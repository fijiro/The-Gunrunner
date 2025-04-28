extends InteractableObject
var sell_slot: ItemSlot
func _ready() -> void:
	super._ready()
	inventory.ui.connect("sold_item", Callable(self, "_sell_item"))
	inventory.ui.connect("put_for_sale", Callable(self, "_update_price"))
	
	sell_slot = inventory.ui.get_node("SellSlot")
	sell_slot.setup(null, inventory)
	
func _sell_item() -> void:
	# Get price label
	if sell_slot.item == null: return
	var label: Label = inventory.ui.get_node("Price")
	var player_inventory = (get_node("/root/Main/Player/PlayerInventory") as PlayerInventory)
	player_inventory.adjust_money(label.text.to_int())
	sell_slot.item.queue_free()
	sell_slot.regenerate_icon(true)
	label.text = "0 €"
func _update_price() -> void:
	# get label Price
	var label: Label = inventory.ui.get_node("Price")
	# get receiver price
	var price = (sell_slot.item as GunPart).price if sell_slot.item != null else 0.0
	label.text = "%s€" % price
