extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 8.0
@export var gravity: float = 20.0
@export var mouse_sensitivity: float = 0.002
var head
var camera
var rotation_y := 0.0
var rotation_x := 0.0
var input_enabled: bool = true 

func _ready() -> void:
	head = $Head
	camera = $Head/Camera3D
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and input_enabled:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-90), deg_to_rad(90))
		rotation.y = rotation_y
		head.rotation.x = rotation_x
func _physics_process(delta):
	if not input_enabled:
		return  # Skip movement if input is disabled
	var input_dir = Vector3.ZERO
	# Get input direction
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	#if Input.is_action_pressed("item_slot_1"):
	input_dir = input_dir.normalized()

	# Rotate input based on camera direction (if needed)
	var direction = global_transform.basis * input_dir
	direction.y = 0
	direction = direction.normalized()

	# Movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	# Move the character
	move_and_slide()
	
func get_camera() -> Camera3D:
	return $Head/Camera3D

func set_input_enabled(enabled: bool):
	input_enabled = enabled
