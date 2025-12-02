class_name Hand extends RigidBody3D
var item: Node3D
@export var recoil_amount: Vector3
@export var snap_amount: float
@export var speed: float
@export var max_distance: float = 0.3
@export var hand_joint: Generic6DOFJoint3D
var current_rotation: Vector3
var target_rotation: Vector3

func _ready() -> void:
	top_level = true
	pass

#TODO: move to Weapon, because weapon stats affect recoil
func recoil_weapon() -> void:
	var recoil = Vector3(
		randf_range(0, recoil_amount.x),
		randf_range(-recoil_amount.y, recoil_amount.y),
		randf_range(-recoil_amount.z, recoil_amount.z))
	apply_impulse(-(item.global_transform.basis * recoil) * 10, item.position)

func reload_weapon() -> void:
	item.ammo = item.magazine.max_rounds

## Reposition item to make hand grip it correctly
func grip_item() -> void:
	if not item: return
	var grip_marker: Marker3D = item.find_child("Left_Hand", true, false)
	if not grip_marker: return
	var item_to_grip: Vector3 = item.to_local(grip_marker.global_position)
	item.position = -item_to_grip # + hand_to_item
	#attach_item_to_hand(grip_marker)

func ungrab_item() -> void:
	item.position = Vector3.ZERO

func set_hand_responsiveness(linear_stiffness: int, angular_stiffness: int) -> void:
	hand_joint.set_param_x(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS, linear_stiffness)
	hand_joint.set_param_y(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS,linear_stiffness)
	hand_joint.set_param_z(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS,linear_stiffness)

	hand_joint.set_param_x(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
	hand_joint.set_param_y(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
	hand_joint.set_param_z(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
