class_name GunPart extends Item

@export var accuracy := 1.0
@export var ergo := 1.0

func _init():
	part = "Gun Part"
	desc = "Description for Gun Part."
	type = "gun_part"
	price = 100
	weight = 1.0

	pass
