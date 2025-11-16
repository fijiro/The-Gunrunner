class_name ItemSlot extends TextureRect
signal dropped_data
signal slot_pressed
var item: Item
var inventory: InventoryBase
var icon_renderer: IconRenderer
var draggable := true
var stack_size := 0
@export var whitelist: Array[String]

func _ready():
	icon_renderer = get_node("/root/Main/IconRenderer")

func setup(item_node: Item, inventory_node: InventoryBase) -> void:
	item = item_node if item_node and !item_node.is_queued_for_deletion() else null
	set_stacks(1 if item else 0)
	inventory = inventory_node
	_regenerate_icon(true)

## @param amount of available nodes
## Returns how many didn't fit in slot.
func set_stacks(amount: int) -> int:
	stack_size = min(amount, item.max_stack if item else 0)
	# Clear an empty slot
	if !stack_size and item:
		item.get_parent().remove_child(item)
		item.queue_free()
		item = null
	_regenerate_icon()
	$StackSizeLabel.visible = stack_size > 1
	$StackSizeLabel.text = "%s" % stack_size
	return amount - stack_size

func _get_drag_data(_at_position: Vector2) -> Variant:
	if !draggable: return null
	#Create drag icon
	var preview = TextureRect.new()
	preview.name = "preview"
	preview.texture = texture
	preview.expand = true
	preview.custom_minimum_size = Vector2(50,50)
	set_drag_preview(preview)
	# drop the data. data has icon,item and inventory
	var data: Dictionary
	data.set("slot", self)
	data.set("shift", Input.is_key_pressed(KEY_SHIFT))
	return data

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var d_slot: ItemSlot = data.get("slot")
	# Cannot drop on itself
	if d_slot == self: return false
	# Old slot must have an item
	elif typeof(data) != TYPE_DICTIONARY or !d_slot.item: return false
	# If new slot has an item, it must be the same type
	elif item != null and d_slot.item.part != item.part: return false
	#Item must be whitelisted if whitelist exists in slot
	elif !whitelist.is_empty() and d_slot.item.type not in whitelist: return false
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# Move data to the new item slot
	var d_slot = data.get("slot") as ItemSlot
	if !d_slot: push_error("ERR: NO SLOT"); return
	# Combine stackable item to fill new slot
	if !item:
		if d_slot.item.max_stack == 1:
			inventory.add_item(d_slot.item, self)
			d_slot.item = null
		else:
			var dupe: Item = d_slot.item.duplicate()
			inventory.add_item(dupe, self)
		stack_size = 0
	# Holding shift moves only one item
	var amount = d_slot.stack_size if !data.get("shift") else 1
	var extra = set_stacks(stack_size + amount)
	d_slot.set_stacks(d_slot.stack_size - amount + extra)

	emit_signal("dropped_data")
	d_slot.emit_signal("dropped_data")

func _regenerate_icon(force: bool = false) -> void:
	texture = await icon_renderer.render_icon(item, force)
	#TODO: Use part icons instead
	$TypeLabel.text = item.type if item else ""
	$PriceLabel.text = "%s$" % item.price if item else ""
	tooltip_text = item.desc if item else ""

func take_one() -> void:
	if !item or !stack_size: return 
	set_stacks(stack_size - 1)

func add_one() -> bool:
	return set_stacks(stack_size + 1)

func is_whitelisted(type: String) -> bool:
	return type == "" or whitelist.is_empty() or whitelist.has(type)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("slot_pressed")

func _on_slot_pressed() -> void:
	pass

func toggle_stylebox_color() -> void:
	var style := ($Outline.get_theme_stylebox("panel") as StyleBoxFlat).duplicate()
	style.border_color = Color.RED if style.border_color == Color.YELLOW else Color.YELLOW
	$Outline.add_theme_stylebox_override("panel", style)
