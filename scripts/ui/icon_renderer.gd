class_name IconRenderer extends Node
var viewport: SubViewport = SubViewport.new()
var camera: Camera3D = Camera3D.new()
func _ready() -> void:
	add_child(viewport)
	viewport.size = Vector2(100, 100)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.add_child(camera)
	camera.look_at_from_position(Vector3(0, 0, 0.3), Vector3.ZERO, Vector3.UP)
	
func render_icon(item: Node3D) -> ImageTexture:
	if item == null: return null
	var clone = item.duplicate()
	clone.visible = true
	viewport.add_child(clone)
	await RenderingServer.frame_post_draw
	var image = viewport.get_texture().get_image()
	clone.queue_free()
	return ImageTexture.create_from_image(image)
