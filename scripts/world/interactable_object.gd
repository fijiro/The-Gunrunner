class_name InteractableObject extends Node3D

@export var zoom_duration: float = 1.0
@export var zoom_target: NodePath
var player_in_range = false
var player_camera: Camera3D
var original_camera_transform: Transform3D
var zoomed_in = false
@export var inventory: InventoryBase

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	# Usually an UI menu has an exit button
	if inventory.ui.has_signal("menu_closed"):
		inventory.ui.connect("menu_closed", Callable(self, "exit_menu"))
	inventory.ui.visible = false

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
	# Zoom in
	zoomed_in = true
	original_camera_transform = player_camera.global_transform
	var target_transform = get_node(zoom_target).global_transform
	var tween = create_tween()
	tween.tween_property(player_camera, "global_transform", target_transform, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	# Set up UI
	inventory.ui.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
#BUG: Spamming input during tween breaks camera
func exit_menu():
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
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
