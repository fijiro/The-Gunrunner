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
	
func _process(_delta: float) -> void:
	#limit_arm_sway()
	#if item is not Weapon: return
	#reset_weapon(_delta)
	#set_hand_responsiveness(1000,1000)
	pass

func recoil_weapon() -> void:
	var recoil = Vector3(
		randf_range(-recoil_amount.x, recoil_amount.x),
		randf_range(-recoil_amount.y, recoil_amount.y),
		randf_range(-recoil_amount.z, recoil_amount.z))
	apply_impulse(-recoil, to_local(item.position))

func reload_weapon() -> void:
	item.ammo = item.magazine.max_rounds
	
func grab_item() -> void:
	var grab_marker: Marker3D = item.find_child("Left_Hand", true, false)
	if not grab_marker: return
	#1. Get x, y, z distance between hand and item
	var b: Vector3 = self.to_local(item.global_position)
	#2. Get distance between item and grab marker
	var a: Vector3 = item.to_local(grab_marker.global_position)
	#2. reposition item to make hand and grip match
	item.position = b - a
	#attach_item_to_hand(grab_marker)

func attach_item_to_hand(grip: Marker3D):
	$GrabJoint.node_b = grip.get_path()
	
func ungrab_item() -> void:
	item.position = Vector3.ZERO
	$GrabJoint.node_b = $GrabJoint.node_a
		
func set_hand_responsiveness(linear_stiffness: int, angular_stiffness: int) -> void:
	hand_joint.set_param_x(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS, linear_stiffness)
	hand_joint.set_param_y(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS,linear_stiffness)
	hand_joint.set_param_z(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS,linear_stiffness)

	hand_joint.set_param_x(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
	hand_joint.set_param_y(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
	hand_joint.set_param_z(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
