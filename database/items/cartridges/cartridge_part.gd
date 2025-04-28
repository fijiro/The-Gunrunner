class_name CartridgePart extends Item

@export var accuracy := 1

func _ready() -> void:
	super._ready()
	part = "Cartridge Part"
	desc = "Standard rifle cartridge."
	type = "cartridge_part"
	price = 1
	weight = 0
	max_stack = 10
	pass
