class_name Bullet extends CartridgePart

func _ready() -> void:
	super._ready()
	part = "bullet"
	desc = "Standard rifle cartridge bullet."
	type = "bullet"
	accuracy = 1
	price = 1
	weight = 0.015
