class_name Receiver extends GunPart
@export var rpm: float = 500

func _init() -> void:
	super._init()
	print("Running Receiver Init")
	part = "Receiver"
	desc = "A standard Receiver."
	type = "receiver"
	accuracy = 1
	price = 100
	weight = 3
	ergo = 1
