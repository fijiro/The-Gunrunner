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

func update_ammo(ammo: int) -> void:
	$Ammo.text = "%s/30" % ammo
