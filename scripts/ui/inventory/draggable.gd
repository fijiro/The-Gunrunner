class_name DraggableItem extends TextureRect
var item: Node3D
var inventory: Node
var icon_renderer: IconRenderer
@export var whitelist: Array[String]
func setup(item_node: Node3D = null, inventory_node: InventoryBase = null) -> void:
	item = item_node
	inventory = inventory_node
	regenerate_icon(true)
	
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
	# drop the data. data has icon,item and inventory
	var slot_data: Dictionary
	slot_data.set("item", item)
	slot_data.set("inventory", inventory)
	slot_data.set("icon", self)
	slot_data.set("whitelist", whitelist)
	return slot_data
	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Old slot must have an item and new slot must be empty
	if typeof(data) == TYPE_DICTIONARY and data.has("item") and data["item"] != null and item == null:
		#Item must be whitelisted if whitelist exists in slot
		if !whitelist.is_empty() and data["item"].type not in whitelist: return false
		else: return true
	else: return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#Assign data to the new item slot
	#print("dropping data ", data)
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
