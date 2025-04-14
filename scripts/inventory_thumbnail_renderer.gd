extends Node

var viewport := SubViewport.new()
var camera := Camera3D.new()
var light := DirectionalLight3D.new()

func _ready():
	viewport.size = Vector2(100, 100)
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	add_child(viewport)

	camera.look_at_from_position(Vector3(0, 0, 0.5), Vector3.ZERO, Vector3.UP)
	viewport.add_child(camera)

	light.light_energy = 2.0
	light.rotation_degrees = Vector3(-45, 45, 0)
	viewport.add_child(light)

func render_icon(item: Node3D) -> Texture2D:
	viewport.size = Vector2(256, 256)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	# This viewport is standalone — not added to main world
	var clone := item.duplicate()
	clone.visible = true
	viewport.add_child(clone)
	camera.transparent_bg = true
	camera.look_at_from_position(Vector3(0, 0, 2), Vector3.ZERO, Vector3.UP)
	viewport.add_child(camera)
	# Optional: soft directional light for contrast
	light.rotation_degrees = Vector3(-45, 45, 0)
	light.light_energy = 1.5
	viewport.add_child(light)
	add_child(viewport)  # Add temporarily to process
	await RenderingServer.frame_post_draw
	var tex := viewport.get_texture()
	remove_child(viewport)
	viewport.queue_free()
	return tex
