class_name Projectile extends Cartridge

func _ready() -> void:
	super._ready()
	part = "projectile"
	desc = "Standard rifle cartridge projectile."
	type = "projectile"
	accuracy = 1
	price = 1
	weight = 0.010
