class_name Player extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 8.0
@export var gravity: float = 20.0
@export var mouse_sensitivity: float = 0.002
@export var escape_ui_scene: PackedScene
@export var inventory: PlayerInventory
@export var head: Head
var escape_ui: CanvasLayer
var rotation_y := 0.0
var rotation_x := 0.0
var input_enabled: bool = true 
var mouse_delta := Vector2.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	escape_ui = escape_ui_scene.instantiate()
	get_node("/root/Main/UI").add_child(escape_ui)
	escape_ui.visible = false

func _unhandled_input(event: InputEvent) -> void:
	# TODO: breaks with InteractableObject
	if event.is_action_pressed("escape"):
		escape_ui.visible = not escape_ui.visible
		input_enabled = not input_enabled
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if not input_enabled else Input.MOUSE_MODE_CAPTURED)
	
	#TODO: 16.09.2025 future me clean this up, will have 10? slots
	elif event.is_action_pressed("item_slot_1"): inventory.equip_slot(0)
	elif event.is_action_pressed("item_slot_2"): inventory.equip_slot(1)
	elif event.is_action_pressed("item_slot_3"): inventory.equip_slot(2)
	
	# Mouse look
	elif event is InputEventMouseMotion and !(event as InputEventMouseMotion).relative.is_zero_approx() and input_enabled:
		mouse_delta = event.relative

func _physics_process(delta):
	if not input_enabled: return
	#Player Actions
	if Input.is_action_just_pressed("reload"): head.reload_input()
	if Input.is_action_pressed("fire"): head.fire_input()
	
	var input_dir = Vector3.ZERO
	# Get input direction
	if Input.is_action_pressed("move_forward"): input_dir.z -= 1
	if Input.is_action_pressed("move_back"): input_dir.z += 1
	if Input.is_action_pressed("move_left"): input_dir.x -= 1
	if Input.is_action_pressed("move_right"): input_dir.x += 1
	input_dir = input_dir.normalized()

	# Rotate player and camera
	rotation_y -= mouse_delta.x * mouse_sensitivity
	rotation_x = clamp(rotation_x - mouse_delta.y * mouse_sensitivity, deg_to_rad(-90), deg_to_rad(90))
	rotation.y = rotation_y
	head.rotation.x = rotation_x
	# Reset mouse delta
	mouse_delta = Vector2.ZERO
	
	# Rotate input based on camera direction
	var direction = global_transform.basis * input_dir
	direction.y = 0
	direction = direction.normalized()
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	
	# Movement
	var target_velocity = direction * speed
	velocity.x = move_toward(velocity.x, target_velocity.x, 20 * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, 20 * delta)
	
	# Move the character
	move_and_slide()

func get_camera() -> Camera3D:
	return $Head/Camera3D

func set_input_enabled(enabled: bool):
	input_enabled = enabled
