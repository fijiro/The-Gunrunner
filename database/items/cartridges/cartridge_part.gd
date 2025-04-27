class_name CartridgePart extends Item

@export var accuracy := 1


func _ready() -> void:
	part = "Cartridge Part"
	desc = "Standard rifle cartridge."
	type = "cartridge_part"
	price = 50
	weight = 0.100
	pass
