class_name PlayerInventory extends InventoryBase

var equipped_index := -1
var equipped_item : Node3D
var money := 0
var player_ui: PlayerUI
func _ready():
	super._ready()
	player_ui = ui
	
func equip_slot(index: int):
	if index < 0 or index >= 3 or !get_ui_slot(index).item: return
	var ui_slot = get_ui_slot(equipped_index)
	# Clear old slot
	if equipped_index > -1:
		ui_slot.draggable = true
		equipped_item.visible = false
		equipped_item.reparent(self)
		player_ui.toggle_stylebox_color(ui_slot.get_node("Outline"))
	
	# Reselecting a slot only clears it
	if index == equipped_index:
		equipped_index = -1
		return

	# Apply new selected slot
	ui_slot = get_ui_slot(index)
	equipped_index = index
	equipped_item = ui_slot.item
	ui_slot.draggable = false
	equipped_item.visible = true
	equipped_item.reparent(get_parent().get_node("Head/Hand"))
	equipped_item.rotation = Vector3.ZERO
	equipped_item.position = Vector3.ZERO
	player_ui.toggle_stylebox_color(ui_slot.get_node("Outline"))

func adjust_money(amount: int) -> void:
	money += amount
	player_ui.update_money(money)
	
