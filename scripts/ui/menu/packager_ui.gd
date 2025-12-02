extends CanvasLayer
signal menu_closed
signal start_packager
func _ready():
	$CloseButton.pressed.connect(_on_close_pressed)
	$PackageButton.pressed.connect(_on_package_pressed)
	
func _on_close_pressed() -> void:
	emit_signal("menu_closed")
func _on_package_pressed() -> void:
	emit_signal("start_packager")
