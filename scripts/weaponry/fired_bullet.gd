class_name FiredBullet extends Bullet

func _ready() -> void:
	start_despawn_timer()
	pass

func on_impact():
	#TODO:
	# Apply damage
	# Apply physics?
	# Count stats
	pass
func start_despawn_timer():
	#TODO: despawn bullet after firing
	await get_tree().create_timer(4).timeout
	print("Removing ", self, " at ", Time.get_ticks_msec())
	queue_free()
