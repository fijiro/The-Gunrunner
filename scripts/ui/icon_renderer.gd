class_name IconRenderer
extends Node3D

var _is_rendering := false
var _queue: Array = []
var _cache: Dictionary = {}
var viewport: SubViewport = SubViewport.new()
var camera: Camera3D = Camera3D.new()

func _ready() -> void:
	add_child(viewport)
	viewport.size = Vector2(100, 100)
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	viewport.add_child(camera)
	camera.global_position = global_position

func render_icon(item: Node3D, force: bool) -> ImageTexture:
	if item == null:
		return null
	if _cache.has(item.name) and not force:
		return _cache[item.name]
	var completer = {}
	completer.done = false
	completer.texture = null
	_queue.append({ "item": item, "completer": completer })
	_process_queue()
	while not completer.done:
		await get_tree().process_frame
	return completer.texture

func _process_queue():
	if _is_rendering or _queue.is_empty():
		return
	_is_rendering = true
	var entry = _queue.pop_front()
	var item: Node3D = entry["item"]
	var completer = entry["completer"]
	var texture = await _render_icon(item)
	_cache[item.name] = texture
	completer.texture = texture
	completer.done = true
	_is_rendering = false
	call_deferred("_process_queue")

func _render_icon(item: Node3D) -> ImageTexture:
	get_child(0).visible = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	var clone = item.duplicate()
	clone.visible = true
	camera.add_child(clone)
	clone.position.z -= 0.3
	await RenderingServer.frame_post_draw
	var image = viewport.get_texture().get_image()
	clone.queue_free()
	get_child(0).visible = false
	return ImageTexture.create_from_image(image)
