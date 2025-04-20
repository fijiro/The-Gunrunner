extends InteractableObject

func _ready():
	super._ready()
	inventory.ui.connect("menu_closed", Callable(self, "exit_menu"))
