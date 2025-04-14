extends Node3D

signal item_added(item)

@export var zoom_duration: float = 1.0
@export var scrate_ui_scene: PackedScene
@export var zoom_target: NodePath
@export var start_item: PackedScene
@export var start_item2: PackedScene
var icon_renderer
var player_in_range = false
var player_camera: Camera3D
var player_inventory: Node
var original_camera_transform: Transform3D
var zoomed_in = false
var ui_instance: CanvasLayer
var items: Array = []
var item_instance
func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	item_instance = start_item.instantiate()
	icon_renderer = preload("res://scripts/inventory_thumbnail_renderer.gd").new()
func _on_body_entered(body):
	if body.has_method("get_camera"):
		player_in_range = true
		player_camera = body.get_camera()
		
		player_inventory = player_camera.get_parent().get_parent().get_node("PlayerInventory")

func _on_body_exited(body):
	if body.has_method("get_camera"):
		player_in_range = false

func _input(event):
	if player_in_range and event.is_action_pressed("interact") and not zoomed_in:
		_zoom_in_and_show_menu()
	if player_in_range and event.is_action_pressed("item_slot_1") and zoomed_in:
		_take_item(items[0])

func _zoom_in_and_show_menu():
	# Disable player input
	if player_camera:
		var player = player_camera.get_parent().get_parent()
		if player.has_method("set_input_enabled"):
			player.set_input_enabled(false)
		var player_ui = get_node("/root/Main/PlayerUI")
		#if player_ui.has_method("set_ui_visible"):
		#	player_ui.set_ui_visible(false)
	zoomed_in = true
	original_camera_transform = player_camera.global_transform
	ui_instance = scrate_ui_scene.instantiate()
	get_tree().root.add_child(ui_instance)
	
	#Add dummy, breaks after
	items.append(item_instance)
	get_node("Inventory").add_child(item_instance)
	add_slot_image(item_instance)
	
	var target_node = get_node(zoom_target)
	var target_transform = target_node.global_transform
	var tween = create_tween()
	tween.tween_property(player_camera, "global_transform", target_transform, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	# Show UI
	ui_instance.visible = true
	# Hook up close callback
	ui_instance.connect("menu_closed", Callable(self, "exit_menu"))
	# Hook up buttons
	#ui_instance.connect("add_grip", Callable(self, "_add_grip"))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func exit_menu():
	if not player_camera:
		return
	var tween = create_tween()
	tween.tween_property(player_camera, "global_transform", original_camera_transform, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	if ui_instance:
		ui_instance.queue_free()
	zoomed_in = false
	
	if player_camera:
		var player = player_camera.get_parent().get_parent()
		if player.has_method("set_input_enabled"):
			player.set_input_enabled(true)
		var player_ui = get_node("/root/Main/PlayerUI")
		if player_ui.has_method("set_ui_visible"):
			player_ui.set_ui_visible(true)
	#_move_part(get_node("ReceiverPosition"))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _take_item(item : Node3D):
	player_inventory.add_item(item)

func add_item(item: Node3D):
	items.append(item)
	item.reparent(get_node("Inventory"))
	#add_slot_image(item)
	var texture = await icon_renderer.render_icon(item)
	var ui_slot = get_ui_slot(0)
	if ui_slot.get_child(0) is TextureRect:
		ui_slot.get_child(0).texture = texture
	item.visible = false

func get_ui_slot(slot : int) -> Control:
	return ui_instance.get_node("Panel/GridContainer/ItemSlot%s" % slot)

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

func can_drop_data(_position, data):
	return data is DraggableItem

func drop_data(_position, data):
	if data.get_parent():
		data.reparent($Inventory)
	emit_signal("item_added", data)

	# Optional: track inventory internally
	print("Item added to inventory:", data.name)
