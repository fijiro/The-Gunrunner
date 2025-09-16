class_name MagazineInventory extends InventoryBase
var magazine_ui: CanvasLayer
var cartridges: Array[Cartridge]
func _ready() -> void:
	magazine_ui = ui
	pass
