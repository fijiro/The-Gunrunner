extends Node3D

@export var zoom_duration: float = 1.0
@export var workbench_ui_scene: PackedScene  # drag your menu scene here
@export var zoom_target: NodePath
@export var gripScene: PackedScene
@export var receiverScene: PackedScene
@export var barrelScene: PackedScene

var player_in_range = false
var player_camera: Camera3D
var original_camera_transform: Transform3D
var zoomed_in = false
var ui_instance: CanvasLayer

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_method("get_camera"):  # assumes player has this method
		player_in_range = true
		player_camera = body.get_camera()

func _on_body_exited(body):
	if body.has_method("get_camera"):
		player_in_range = false

func _input(event):
	if player_in_range and event.is_action_pressed("interact") and not zoomed_in:
		_zoom_in_and_show_menu()

func _zoom_in_and_show_menu():
	# Disable player input
	if player_camera:
		var player = player_camera.get_parent().get_parent()
		if player.has_method("set_input_enabled"):
			player.set_input_enabled(false)
		var player_ui = get_node("/root/Main/PlayerUI")
		if player_ui.has_method("set_ui_visible"):
			player_ui.set_ui_visible(false)
	zoomed_in = true
	original_camera_transform = player_camera.global_transform
	var target_node = get_node(zoom_target)
	var target_transform = target_node.global_transform
	var tween = create_tween()
	tween.tween_property(player_camera, "global_transform", target_transform, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await tween.finished

	# Show UI
	ui_instance = workbench_ui_scene.instantiate()
	get_tree().root.add_child(ui_instance)
	ui_instance.visible = true

	# Hook up close callback
	ui_instance.connect("menu_closed", Callable(self, "exit_workbench"))
	# Hook up buttons
	ui_instance.connect("add_grip", Callable(self, "_add_grip"))
	ui_instance.connect("add_receiver", Callable(self, "_add_receiver"))
	ui_instance.connect("add_barrel", Callable(self, "_add_barrel"))
	ui_instance.connect("build_weapon", Callable(self, "_build_weapon"))

func exit_workbench():
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
	_move_part(get_node("ReceiverPosition"))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _add_grip(): _add_part("Grip", gripScene)
func _add_receiver(): _add_part("Receiver", receiverScene)
func _add_barrel(): _add_part("Barrel", barrelScene)

func _add_part(part: String, partScene: PackedScene):
	var part_pos = get_node(part + "Position")
	var part_instance = partScene.instantiate()
	if part_pos && part_instance:
		#print("FOUND PARTS: ", part_pos.get_child_count())
		if part_pos.get_child_count() == 1: part_pos.remove_child(part_pos.get_child(0))
		part_pos.add_child(part_instance)
		part_instance.position = Vector3.ZERO
	#else: print("ERROR: MISSING PART")

func _build_weapon():
	var grip = get_node("GripPosition").get_child(0) if get_node("GripPosition").get_child_count() > 0 else null
	var receiver = get_node("ReceiverPosition").get_child(0) if get_node("ReceiverPosition").get_child_count() > 0 else null
	var barrel = get_node("BarrelPosition").get_child(0) if get_node("BarrelPosition").get_child_count() > 0 else null
	if null in [grip, receiver, barrel]: return
	grip.reparent(receiver, false)
	barrel.reparent(receiver, false)
	# Calculate correct positions for part
	var barrel_to_receiver = barrel.find_child("Receiver_Attach")
	var receiver_to_barrel = receiver.find_child("Barrel_Attach")
	barrel.global_transform = receiver_to_barrel.global_transform * barrel_to_receiver.transform.affine_inverse()
	var grip_to_receiver = grip.find_child("Receiver_Attach")
	var receiver_to_grip = receiver.find_child("Grip_Attach")
	grip.global_transform = receiver_to_grip.global_transform * grip_to_receiver.transform.affine_inverse()
	
func _move_part(item_slot : Node3D):
	var item = item_slot.get_child(0)
	#var workbench_slot = ui_instance.get_node("UI/%sBox" % [item.type])
	var player_inventory = player_camera.get_parent().get_parent().get_node("PlayerInventory")
	player_inventory.add_item(item)
	return
