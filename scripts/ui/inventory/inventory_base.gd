# Inventory.gd
class_name InventoryBase extends Node3D

@export var ui_scene: PackedScene
var ui: CanvasLayer
#var items: Array[Node3D] = []
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
	for item_slot: DraggableItem in ui.get_node("ItemSlots").get_children():
		item_slot.setup(null, self)
		#item_slot.dropped_data.connect(add_item)
	#Add existing items in inventory
	for child in get_children():
		add_item(child)
		
## Return true if item was successfully added to inventory.
func add_item(item: Node3D) -> bool:
	if item == null: return false
	var item_slot: DraggableItem = get_first_empty_slot()
	if(item_slot == null): return false
	
	if item.get_parent(): item.reparent(self)
	else: add_child(item)
	item_slot.setup(item, self)
	item.visible = false
	return true

## Returns null or DraggableItem slot for index.
func get_ui_slot(index: Variant) -> DraggableItem:
	if index is int:
		return ui.get_node("ItemSlots").get_child(index) if index > -1 else null
	elif index is String:
		return ui.get_node("ItemSlots").get_node(index)
	else: return null
	
## Returns all inventory slots.
func get_slots() -> Array[DraggableItem]:
	var slots: Array[DraggableItem] = []
	for item in ui.get_node("ItemSlots").get_children():
		if item is DraggableItem: slots.append(item)
	return slots
## Returns first empty slot under ItemSlots.
func get_first_empty_slot() -> DraggableItem:
	for slot: DraggableItem in ui.get_node("ItemSlots").get_children():
		if slot.item == null: return slot
	return null
## Returns existing items under ItemSlots
func get_items() -> Dictionary[String, Item]:
	var items: Dictionary[String, Item] = {}
	for slot in get_slots():
		if slot.item != null: items.set((slot.item as Item).type, slot.item)
	return items
