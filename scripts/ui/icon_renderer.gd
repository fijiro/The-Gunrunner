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
	var clone: GunPart = item.duplicate()
	clone.visible = true
	clone.position = Vector3.ZERO
	clone.rotation = Vector3.ZERO
	camera.add_child(clone)
	clone.position.z -= 0.3
	var aabb: AABB = get_node_aabb(clone)
	var b: float = aabb.get_longest_axis_size()
	var scale_multi = Vector3(0.35/b,0.35/b, 0.35/b)
	clone.scale *= scale_multi
	await RenderingServer.frame_post_draw
	var image = viewport.get_texture().get_image()

	clone.queue_free()
	get_child(0).visible = false # Hide background
	return ImageTexture.create_from_image(image)

## Return the [AABB] of the node. 
## Credit: u/Magodra
func get_node_aabb(node : Node, exclude_top_level_transform: bool = true) -> AABB:
	var bounds : AABB = AABB()
	# Get the aabb of the visual instance
	if node is MeshInstance3D:
		bounds = node.get_aabb();
	# Recurse through all children
	for child in node.get_children():
		var child_bounds : AABB = get_node_aabb(child, false)
		if bounds.size == Vector3.ZERO:
			bounds = child_bounds
		else:
			bounds = bounds.merge(child_bounds)
	if !exclude_top_level_transform: bounds = node.transform * bounds
	return bounds
	
