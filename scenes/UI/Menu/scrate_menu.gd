extends CanvasLayer
signal menu_closed
signal slot1

func _ready():
	get_node("CloseButton").pressed.connect(_on_close_pressed)

func _on_close_pressed():
	emit_signal("menu_closed")
