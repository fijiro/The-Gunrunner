class_name Propellant extends Cartridge
func _ready() -> void:
	super._ready()
	part = "Propellant"
	desc = "Standard cartridge propellant."
	type = "propellant"
	price = 1
	weight = 0
	max_stack = 10
	pass
