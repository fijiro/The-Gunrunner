class_name DraggableItem extends TextureRect
var item: Node3D
var inventory: Node
var icon_renderer: IconRenderer
var type: String = "type"

func setup(item_node: Node3D = null, inventory_node: InventoryBase = null) -> void:
	item = item_node
	inventory = inventory_node
	if name == "GripSlot": type = "grip"
	elif name == "ReceiverSlot": type = "receiver"
	elif name == "BarrelSlot": type = "barrel"
	regenerate_icon()
	
func _ready():
	icon_renderer = get_node("/root/Main/IconRenderer")
	mouse_filter = Control.MOUSE_FILTER_PASS

func _get_drag_data(_at_position: Vector2) -> Variant:
	#Create drag icon
	var preview = TextureRect.new()
	preview.name = "preview"
	preview.texture = texture
	preview.expand = true
	preview.custom_minimum_size = Vector2(50,50)
	set_drag_preview(preview)
	# drop the data. data has texture and icon
	var item_data: Dictionary
	item_data.set("item", item)
	item_data.set("inventory", inventory)
	item_data.set("icon", self)
	item_data["type"] = item.type if item else null
	return item_data
	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Old slot must have an item and new slot must be empty
	if typeof(data) == TYPE_DICTIONARY and data.has("item") and data["item"] != null and item == null:
		#Slot type must match item type if defined 
		var slot_type = data["type"]
		#print("SLOT TYPE: ", type, " FOR ITEM: ", slot_type)
		if type != "type" and type != slot_type: return false
		return true
	else: return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#Assign data to the new item slot
	print("dropping data ", data)
	data["inventory"].remove_child(data["item"])
	inventory.add_child(data["item"])
	item = data["item"]
	(data["icon"] as DraggableItem).item = null
	# Regenerate slot icon
	regenerate_icon()
	# Regenerate old icon
	(data["icon"] as DraggableItem).regenerate_icon()
	
func regenerate_icon(force: bool = false):
	texture = await icon_renderer.render_icon(item, force)
