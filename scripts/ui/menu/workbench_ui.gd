extends CanvasLayer

signal menu_closed
signal build_weapon
func _ready():
	get_node("CloseButton").pressed.connect(_on_close_pressed)
	get_node("BuildButton").pressed.connect(_on_build_pressed)

func _on_close_pressed():
	emit_signal("menu_closed")
	
func _on_build_pressed():
	emit_signal("build_weapon")
