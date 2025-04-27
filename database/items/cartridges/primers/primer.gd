class_name Primer extends CartridgePart

func _ready() -> void:
	super._ready()
	part = "primer"
	desc = "Standard rifle cartridge primer."
	type = "primer"
	price = 1
	weight = 0.005
