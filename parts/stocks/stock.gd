class_name Stock extends GunPart

func _init() -> void:
	super._init()
	part = "Stock"
	desc = "A standard stock."
	type = "stock"
	accuracy = 1.5
	price = 50
	weight = 1.5
	ergo = 2
