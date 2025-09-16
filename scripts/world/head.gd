#Head
class_name Head extends Node3D
var weapon: Weapon
@export var hand: Node3D
@export var recoil_amount: Vector3
@export var snap_amount: float
@export var speed: float
var current_rotation: Vector3
var target_rotation: Vector3
var recoil_offset: Vector3 = Vector3.ZERO
#var recoil_rotation: Vector3 = Vector3.ZERO
var recoil_velocity: Vector3 = Vector3.ZERO
#var rotation_velocity: Vector3 = Vector3.ZERO

func setup() -> void:
	if weapon:
		weapon.weapon_fired.disconnect(add_recoil)
		weapon = null
	
	if !hand.get_child_count(): return
	weapon = hand.get_child(0)
	weapon.weapon_fired.connect(add_recoil)

func _process(delta: float) -> void:
	if !weapon: return
	# Handle input here so unequipped weapons don't care about input
	if Input.is_action_pressed("fire") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and weapon.can_fire: 
		weapon.fire()
	
	target_rotation = lerp(target_rotation, Vector3.ZERO, speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, snap_amount * delta)
	#weapon.basis = Quaternion.from_euler(current_rotation)

func add_recoil() -> void:
	target_rotation += Vector3(
		randf_range(-recoil_amount.x, recoil_amount.x),
		randf_range(-recoil_amount.y, recoil_amount.y),
		randf_range(-recoil_amount.z, recoil_amount.z))
