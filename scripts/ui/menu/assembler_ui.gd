extends CanvasLayer
signal menu_closed
signal start_assembly
func _ready():
	$CloseButton.pressed.connect(_on_close_pressed)
	$AssembleButton.pressed.connect(_on_assembly)
	
func _on_close_pressed() -> void:
	emit_signal("menu_closed")
func _on_assembly() -> void:
	emit_signal("start_assembly")
