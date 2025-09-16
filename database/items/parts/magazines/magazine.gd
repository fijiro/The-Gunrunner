class_name Magazine extends GunPart
@export var max_rounds = 30
func _init():
	super._init()
	part = "Magazine"
	desc = "A standard magazine."
	type = "magazine"
	weight = 0.5
	price = 25
	ergo = 1
