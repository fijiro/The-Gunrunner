class_name PlayerUI extends CanvasLayer
var selected_slots := []
#signal pressed
func _ready() -> void:
	
	pass
	# .connect("pressed", _on_slot_pressed)
func set_ui_visible(enabled: bool) -> void: 
	visible = enabled
	
func update_money(money: int) -> void:
	$Money.text = "%s €" % money

func toggle_stylebox_color(panel: Panel) -> void:
	var style := (panel.get_theme_stylebox("panel") as StyleBoxFlat).duplicate()
	style.border_color = Color.RED if style.border_color == Color.YELLOW else Color.YELLOW
	panel.add_theme_stylebox_override("panel", style)
