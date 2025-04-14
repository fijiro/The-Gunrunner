# Inventory.gd
extends Node

# item slots (you can expand this later to hold more data)
var items: Array = []
var equipped_index := -1  # -1 means nothing equipped

func add_item(item: Node3D):
	if item == null: return
	items.append(item)
	item.reparent(self)
	add_slot_image(item)
	item.visible = false

func equip_item(index: int):
	if index < 0 or index >= items.size():
		print("Invalid item index")
		return

	# Hide all items
	for item in items:
		item.visible = false

	# Show selected item
	var selected_item = items[index]
	selected_item.visible = true
	equipped_index = index
	get_parent().get_node("Hand").add_child(selected_item)

func get_equipped_item() -> Node3D:
	if equipped_index >= 0 and equipped_index < items.size():
		return items[equipped_index]
	return null

func get_ui_slot(slot : int) -> Control:
	return get_node("/root/Main/PlayerUI/GridContainer/ItemSlot%s" % slot)

func add_slot_image(item : Node3D) -> Texture2D:
	var captured_texture: Texture2D
	var ui_slot = get_ui_slot(0)
	var viewport := SubViewport.new()
	viewport.size = Vector2(100, 100)
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	var clone = item.duplicate()
	viewport.add_child(clone)	
	var camera := Camera3D.new()
	camera.look_at_from_position(Vector3(0, 0, 0.3), Vector3.ZERO, Vector3.UP)
	#item.add_child(camera)
	#item.add_child(viewport)
	clone.add_child(camera)
	add_child(viewport)
	await RenderingServer.frame_post_draw
	
	# Grab texture
	captured_texture = viewport.get_texture()
	ui_slot.texture = captured_texture
	#remove_child(viewport)
	clone.queue_free()
	#viewport.queue_free()
	return captured_texture
