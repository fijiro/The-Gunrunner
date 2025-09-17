class_name Hand extends RigidBody3D
var weapon: Weapon
@export var recoil_amount: Vector3
@export var snap_amount: float
@export var speed: float
var current_rotation: Vector3
var target_rotation: Vector3

func _process(delta: float) -> void:
	if not weapon: return
	target_rotation = lerp(target_rotation, Vector3.ZERO, speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, snap_amount * delta)
	weapon.basis = Quaternion.from_euler(current_rotation)

func recoil_weapon() -> void:
	target_rotation += Vector3(
		randf_range(-recoil_amount.x, recoil_amount.x),
		randf_range(-recoil_amount.y, recoil_amount.y),
		randf_range(-recoil_amount.z, recoil_amount.z))
	apply_impulse(-current_rotation*5)

func reload_weapon():
	weapon.ammo = weapon.magazine.max_rounds
