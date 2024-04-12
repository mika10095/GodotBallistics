extends Node3D
signal register_camera
var id: int
var camera: Camera3D

@export var fixed_free: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FollowObjectManager.use_camera.connect(_on_use_camera)
	FollowObjectManager.clear_cameras.connect(_on_clear_cameras)
	id = FollowObjectManager.register_camera()
	print_debug("Camera created ID: " + str(id))
	for child in get_children():
		if child is Camera3D:
			camera = child
	camera.set_process(false)
	#if get_parent_node_3d().get_parent_node_3d().name == "Player":
	#	camera.set_process(true)
	#	id = 1
	#	camera.make_current()


func _on_clear_cameras() -> void:
	print_debug("old" + str(id))
	id = FollowObjectManager.register_camera()
	print_debug("new" + str(id))


func _on_use_camera(currentid: int) -> void:
	if currentid == id:
		camera.freelook_enabled = fixed_free
		camera.freelook_fixed = fixed_free
		print_debug("I am current " + str(id))

		camera.set_process(true)
		camera.make_current()
	else:
		camera.set_process(false)
		camera.clear_current()
