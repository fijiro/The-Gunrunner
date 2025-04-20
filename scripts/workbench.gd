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
@onready var inventory: WorkbenchInventory = $WorkbenchInventory
func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	inventory.ui.visible = false
	# Hook up close callback and buttons
	inventory.ui.connect("menu_closed", Callable(self, "exit_workbench"))
	#inventory.ui.connect("add_grip", Callable(self, "_add_grip"))
	#inventory.ui.connect("add_receiver", Callable(self, "_add_receiver"))
	#inventory.ui.connect("add_barrel", Callable(self, "_add_barrel"))
	inventory.ui.connect("build_weapon", Callable(self, "_build_weapon"))


func _on_body_entered(body):
	if body.has_method("get_camera"):
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
	zoomed_in = true
	original_camera_transform = player_camera.global_transform
	var target_transform = get_node(zoom_target).global_transform
	var tween = create_tween()
	tween.tween_property(player_camera, "global_transform", target_transform, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await tween.finished

	# Show UI
	inventory.ui.visible = true
func exit_workbench():
	if not player_camera:
		return
	var tween = create_tween()
	tween.tween_property(player_camera, "global_transform", original_camera_transform, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	inventory.ui.visible = false
	zoomed_in = false
	
	if player_camera:
		var player = player_camera.get_parent().get_parent()
		if player.has_method("set_input_enabled"):
			player.set_input_enabled(true)
	#_move_part(get_node("ReceiverPosition"))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func _add_grip(): _add_part("Grip", gripScene)
#func _add_receiver(): _add_part("Receiver", receiverScene)
#func _add_barrel(): _add_part("Barrel", barrelScene)

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
	#var grip = get_node("GripPosition").get_child(0) if get_node("GripPosition").get_child_count() > 0 else null
	#var receiver = get_node("ReceiverPosition").get_child(0) if get_node("ReceiverPosition").get_child_count() > 0 else null
	#var barrel = get_node("BarrelPosition").get_child(0) if get_node("BarrelPosition").get_child_count() > 0 else null
	var grip = (inventory.get_ui_slot(0) as DraggableItem).item
	var barrel = (inventory.get_ui_slot(2) as DraggableItem).item
	var receiver = (inventory.get_ui_slot(1) as DraggableItem).item
	if null in [grip, receiver, barrel]: return
	else: print("OMG BUILD POSSIBLE HOLY SHIT")
	grip.visible = true
	grip.global_position = (get_node("GripPosition") as Marker3D).global_position
	grip.rotation = (get_node("GripPosition") as Marker3D).rotation
	receiver.visible = true
	receiver.global_position = (get_node("GripPosition") as Marker3D).global_position
	receiver.rotation = (get_node("GripPosition") as Marker3D).rotation
	barrel.visible = true
	barrel.global_position = (get_node("GripPosition") as Marker3D).global_position
	barrel.rotation = (get_node("GripPosition") as Marker3D).rotation
	grip.reparent(receiver, false)
	barrel.reparent(receiver, false)
	# Calculate correct positions for part
	var barrel_to_receiver = barrel.find_child("Receiver_Attach")
	var receiver_to_barrel = receiver.find_child("Barrel_Attach")
	barrel.global_transform = receiver_to_barrel.global_transform * barrel_to_receiver.transform.affine_inverse()
	var grip_to_receiver = grip.find_child("Receiver_Attach")
	var receiver_to_grip = receiver.find_child("Grip_Attach")
	grip.global_transform = receiver_to_grip.global_transform * grip_to_receiver.transform.affine_inverse()
	#ItemSlot Based implementation
	(inventory.get_ui_slot(0) as DraggableItem).item = null
	(inventory.get_ui_slot(0) as DraggableItem).regenerate_icon()
	(inventory.get_ui_slot(2) as DraggableItem).item = null
	(inventory.get_ui_slot(2) as DraggableItem).regenerate_icon()
	receiver.position = Vector3(0,0,0)
	#receiver.rotation = rotation
	(inventory.get_ui_slot(1) as DraggableItem).regenerate_icon(true)
	
#func _move_part(item_slot : Node3D):
#	var item = item_slot.get_child(0)
	#var workbench_slot = ui_instance.get_node("UI/%sBox" % [item.type])
#	var player_inventory = player_camera.get_parent().get_parent().get_node("PlayerInventory")
#	player_inventory.add_item(item)
#	return
