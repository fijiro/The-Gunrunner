class_name Barrel extends GunPart

func _init():
	super._init()   # This would be needed if you need GunPart's init to run
	part = "Barrel"
	desc = "A standard barrel for rifles."
	type = "barrel"
	accuracy = 2
	price = 150
	weight = 2.5
	ergo = 0.8
