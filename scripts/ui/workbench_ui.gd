extends CanvasLayer

signal menu_closed
signal add_grip
signal add_receiver
signal add_barrel
signal build_weapon
func _ready():
	get_node("CloseButton").pressed.connect(_on_close_pressed)
	get_node("AddGrip").pressed.connect(_on_grip_pressed)
	get_node("AddReceiver").pressed.connect(_on_receiver_pressed)
	get_node("AddBarrel").pressed.connect(_on_barrel_pressed)
	get_node("BuildButton").pressed.connect(_on_build_pressed)

func _on_close_pressed():
	emit_signal("menu_closed")
	
func _on_grip_pressed():	
	emit_signal("add_grip")
func _on_receiver_pressed():
	emit_signal("add_receiver")
func _on_barrel_pressed():
	emit_signal("add_barrel")
func _on_build_pressed():
	emit_signal("build_weapon")
