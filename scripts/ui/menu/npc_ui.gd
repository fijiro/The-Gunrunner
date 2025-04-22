extends CanvasLayer
signal menu_closed
signal sold_item
signal put_for_sale
func _ready():
	$CloseButton.pressed.connect(_on_close_pressed)
	$SellButton.pressed.connect(_on_sell_pressed)
	$SellSlot.dropped_data.connect(_on_for_sale)
func _on_close_pressed() -> void:
	emit_signal("menu_closed")
func _on_sell_pressed() -> void:
	emit_signal("sold_item")
func _on_for_sale() -> void:
	emit_signal("put_for_sale")
	
