class_name Hand extends RigidBody3D
var weapon: Weapon
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
	# Recoil arm
	if not weapon: return
	#reset_weapon(_delta)
	#set_hand_responsiveness(1000,1000)
	pass

func recoil_weapon() -> void:
	target_rotation += Vector3(
		randf_range(-recoil_amount.x, recoil_amount.x),
		randf_range(-recoil_amount.y, recoil_amount.y),
		randf_range(-recoil_amount.z, recoil_amount.z))
	apply_impulse(-current_rotation*5)

func reload_weapon() -> void:
	weapon.ammo = weapon.magazine.max_rounds
	
func reset_weapon(delta: float) -> void:
	target_rotation = lerp(target_rotation, Vector3.ZERO, speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, snap_amount * delta)
	weapon.basis = Quaternion.from_euler(current_rotation)
	
func set_hand_responsiveness(linear_stiffness: int, angular_stiffness: int) -> void:
	hand_joint.set_param_x(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS, linear_stiffness)
	hand_joint.set_param_y(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS,linear_stiffness)
	hand_joint.set_param_z(hand_joint.Param.PARAM_LINEAR_SPRING_STIFFNESS,linear_stiffness)
	
	hand_joint.set_param_x(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
	hand_joint.set_param_y(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
	hand_joint.set_param_z(hand_joint.Param.PARAM_ANGULAR_SPRING_STIFFNESS,angular_stiffness)
	
	
