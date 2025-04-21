# Inventory.gd
class_name InventoryBase extends Node3D

@export var ui_scene: PackedScene
var ui: CanvasLayer
var items: Array[Node3D] = []
# TODO: When ui is created: 
# 1. Generate inventory (3D nodes) and set them invisible ✔
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
	#add_item(dummy_scene.instantiate())
	for child in get_children():
		add_item(child)
		pass

func add_item(item: Node3D) -> bool:
	if item == null: return false
	items.append(item)
	if item.get_parent(): item.reparent(self)
	else: add_child(item)
	var item_slot: DraggableItem = get_ui_slot(items.find(item))
	item_slot.setup(item, self)
	item.visible = true
	return true

## Returns null or TextureRect slot for item.
func get_ui_slot(index: int) -> DraggableItem:
	return ui.get_node("ItemSlots").get_child(index) if index > -1 else null
	
func get_slots() -> Array[DraggableItem]:
	var slots: Array[DraggableItem] = []
	for item in ui.get_node("ItemSlots").get_children():
		if item is DraggableItem: slots.append(item as DraggableItem)
		else: push_warning("Item is not a DraggableItem!")
	return slots
