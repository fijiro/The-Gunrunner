class_name Case extends CartridgePart

func _ready() -> void:
	super._ready()
	part = "case"
	desc = "Standard rifle cartridge case."
	type = "case"
	accuracy = 1
	price = 1
	weight = 0.005
