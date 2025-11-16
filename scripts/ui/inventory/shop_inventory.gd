class_name ShopInventory extends InventoryBase
var shop_list: Array[ShopSlot]
func _ready() -> void:
	super._ready()
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

func _update_price() -> void:
	var price := 0
	for slot: ShopSlot in shop_list:
		price += slot.item.price
	(ui.get_node("PriceLabel") as Label).text = str(price) + " $"
