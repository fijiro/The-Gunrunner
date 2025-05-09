# Inventory.gd
class_name InventoryBase extends Node3D

@export var ui_scene: PackedScene
var ui: CanvasLayer
var items: Array[Node3D] = []
# When inventory is created: 
# 1. Generate UI, items (3D nodes) and set them invisible ✔
# 	1.1 Dummy values for now ✔
# 2. Assign 3D_inventory to ui item slots ✔
# 	2.1 generate a pointer to the ui ✔
# 3. Dynamic items[] array size
func _ready() -> void:
	# Generate inventory UI
	ui = ui_scene.instantiate()
	get_node("/root/Main/UI").add_child(ui)
	#Connect all nodes to item slots
	for item_slot: TextureRect in ui.get_node("ItemSlots").get_children():
		item_slot.setup(null, self)
	#Add existing items in inventory
	for child in get_children():
		add_item(child)
		
## Returns was item successfully added to inventory.
func add_item(item: Node3D) -> bool:
	if item == null: return false
	items.append(item)
	if item.get_parent(): item.reparent(self)
	else: add_child(item)
	var item_slot: DraggableItem = get_ui_slot(items.find(item))
	item_slot.setup(item, self)
	item.visible = false
	return true

## Returns null or DraggableItem slot for index.
func get_ui_slot(index: int) -> DraggableItem:
	return ui.get_node("ItemSlots").get_child(index) if index > -1 else null
	
## Returns all inventory slots.
func get_slots() -> Array[DraggableItem]:
	var slots: Array[DraggableItem] = []
	for item in ui.get_node("ItemSlots").get_children():
		if item is DraggableItem: slots.append(item)
	return slots
