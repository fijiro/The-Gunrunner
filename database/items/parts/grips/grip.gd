class_name Grip extends GunPart

func _init() -> void:
	super._init()   # This would be needed if you need GunPart's init to run
	part = "Grip"
	desc = "A standard Grip."
	type = "grip"
	accuracy = 1
	price = 50
	weight = 0.5
	ergo = 3
