class_name Weapon extends GunPart
@export var bullet_scene: PackedScene
@export var case_scene: PackedScene
var magazine: Magazine
var weapon: GunPart
var can_fire := true
var is_equipped := false
var bullet_script := preload("res://scripts/weaponry/fired_bullet.gd")
var weapon_name := "Pea Shooter"
var rpm: float = 100
func _process(_delta):
	# TODO: and not in menu
	if Input.is_action_pressed("fire") and can_fire and is_equipped:
		fire()

func fire():
	can_fire = false
	var bullet: RigidBody3D = bullet_scene.instantiate()
	bullet.set_script(bullet_script)
	# TODO: spawn bullet at the end of barrel
	bullet.global_transform = global_transform
	get_tree().current_scene.add_child(bullet)
	var case: RigidBody3D = case_scene.instantiate()
	case.global_transform = global_transform
	get_tree().current_scene.add_child(case)
	# Apply impulse in the forward (local -Z) direction
	# TODO: calculate impulse power from cartridge parts
	# and recoil
	var direction = bullet.transform.basis.x.normalized()
	var impulse = direction * 10 # Adjust the magnitude as needed
	bullet.apply_impulse(impulse)
	# TODO: Spawn case at ejector
	direction = case.transform.basis.z.normalized()
	case.apply_impulse(direction)
	# Firerate from rpm
	await get_tree().create_timer(1/(rpm/60)).timeout
	can_fire = true
	await get_tree().create_timer(1).timeout
	case.queue_free()
	
func set_equipped(equipped):
	is_equipped = equipped
