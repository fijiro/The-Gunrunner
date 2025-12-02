extends CanvasLayer
signal menu_closed
signal buy_pressed
signal amount_changed(value: float)

func _on_close_pressed():
	emit_signal("menu_closed")

func _on_buy_pressed():
	emit_signal("buy_pressed")

func _on_value_changed(value: float) -> void:
	emit_signal("amount_changed", value)
