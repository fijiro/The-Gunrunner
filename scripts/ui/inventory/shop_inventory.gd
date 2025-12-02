class_name ShopInventory extends InventoryBase
var shop_list: Array[ShopSlot]

func _ready() -> void:
	super._ready()
	ui.connect("amount_changed", _on_amount_changed)
	# Hide unused slots
	for slot: ShopSlot in get_slots():
		if not slot.item: 
			slot.get_parent().visible = false
		else: 
			slot.get_parent().get_node("ItemLabel").text = slot.item.desc + "\nWeight: %s, Ergo: %s" % [slot.item.weight, slot.item.ergo]

func shop_slot_pressed(slot: ShopSlot) -> void:
	if shop_list.has(slot): shop_list.erase(slot)
	else: shop_list.append(slot)
	_update_price()

func _update_price(amount: float = 0) -> void:
	var price := 0
	if not amount:
		amount = (ui.get_node("AmountBox") as SpinBox).value
	for slot: ShopSlot in shop_list:
		price += int(slot.item.price * amount)
	(ui.get_node("PriceLabel") as Label).text = str(price) + " $"


func _on_amount_changed(value: float) -> void:
	_update_price(value)
