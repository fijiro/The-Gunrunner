class_name Cartridge extends Item

@export var accuracy := 1

func _ready() -> void:
	super._ready()
	part = "Cartridge"
	desc = "Standard rifle cartridge."
	type = "cartridge"
	price = 1
	weight = 0
	max_stack = 10
	pass
