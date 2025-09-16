#Head
class_name Head extends Node3D
var weapon: Weapon
@export var recoil_amount: Vector3
@export var snap_amount: float
@export var speed: float
var current_rotation: Vector3
var target_rotation: Vector3
var recoil_offset: Vector3 = Vector3.ZERO
#var recoil_rotation: Vector3 = Vector3.ZERO
var recoil_velocity: Vector3 = Vector3.ZERO
#var rotation_velocity: Vector3 = Vector3.ZERO

func setup() -> bool:
	weapon = find_child("Hand").get_child(0)
	if not weapon: return false
	#weapon.connect("fire_weapon", Callable(self, "fire"))
	weapon.weapon_fired.connect(add_recoil)
	return true
	
func _process(delta: float) -> void:
	if !weapon: return
	# Handle input here so unequipped weapons don't care about input
	if Input.is_action_pressed("fire") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: 
		if weapon.can_fire and weapon.is_equipped:
			weapon.fire()
	
	target_rotation = lerp(target_rotation, Vector3.ZERO, speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, snap_amount * delta)
	weapon.basis = Quaternion.from_euler(current_rotation)

func add_recoil() -> void:
	target_rotation += Vector3(
		randf_range(-recoil_amount.x, recoil_amount.x),
		randf_range(-recoil_amount.y, recoil_amount.y),
		randf_range(-recoil_amount.z, recoil_amount.z))
	
#func _process(_delta):
#	if Input.is_action_pressed("fire") and Input.mouse_mode == #Input.MOUSE_MODE_CAPTURED: 
#		if not weapon:
#			setup()
#		if weapon and weapon.can_fire and weapon.is_equipped:
#			fire()
#	
#func fire():
#	# scale recoil by weapon stats
#	#print((weapon.bullet_script as FiredBullet).weight)
#	var kick_strength = 2 / weapon.weight*20      # heavier = less movement
#	# Max Kick is 10, minimum 1
#	# Weapon weight from 1 to 10
#	# 
#	#var rotation_strength = 2.0 / weapon.weight*10  # heavier = less #rotation
#	# add recoil impulse
#	recoil_velocity.x -= kick_strength  # push backwards along local -X
#	#rotation_velocity.x -= rotation_strength # pitch up
#
#	weapon.fire()
#
#func _physics_process(delta: float) -> void:
#	if not weapon:
#		return
#	
#	# ergo controls how fast recoil resets
#	var reset_speed = 10 * weapon.ergo
#	
#	# spring-like interpolation back to zero
#	recoil_offset = recoil_offset.move_toward(Vector3.ZERO, reset_speed * #delta)
#	#recoil_rotation = recoil_rotation.move_toward(Vector3.ZERO, #reset_speed * delta)
#	
#	# apply velocity
#	recoil_offset += recoil_velocity * delta
#	#recoil_rotation += rotation_velocity * delta
#	
#	# dampen velocity (so it stops adding forever)
#	recoil_velocity = recoil_velocity.move_toward(Vector3.ZERO, #reset_speed * delta)
#	#rotation_velocity = rotation_velocity.move_toward(Vector3.ZERO, #reset_speed * delta)
#	
#	# apply to weapon transform
#	weapon.transform.origin = recoil_offset
#	#weapon.rotation_degrees = recoil_rotation
#
