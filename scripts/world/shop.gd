extends InteractableObject
@export var shipment_scene: PackedScene
@export var item_slot_scene: PackedScene
func _ready():
	super._ready()
	inventory.ui.connect("buy_pressed", _buy_shipment)
# TODO:
# Select part and amount
# Buy shipment action
# Deliver shipment
func _buy_shipment() -> void:
	var price := int((inventory.ui.get_node("PriceLabel") as Label).text)
	# if price > player.inventory.money: return
	player.inventory.adjust_money(-price)
	_deliver_shipment()
	_clear_shop()
	
func _deliver_shipment() -> void:
	var shipment: ShipmentCrate = shipment_scene.instantiate()
	add_child(shipment)
	for slot: ShopSlot in (inventory as ShopInventory).shop_list:
		if not shipment.inventory.add_item(slot.item):
			print("ERROR ADDING ITEM TO SHIPMENT")

	shipment.position += Vector3(0,0,2)
	
func _clear_shop() -> void:
	# Reset selected items
	# Reset price
	# Reset amount
	pass
