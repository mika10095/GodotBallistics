extends Node
signal use_camera
signal clear_cameras
var cameraid: int = 1
var cameras: Array = []
@export var currentcamera: int = 1


# Called when the node enters the scene tree for the first time.
func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("NextCamera"):
		set_current_camera(2)

	if Input.is_action_just_pressed("PreviousCamera"):
		set_current_camera(1)

	if Input.is_action_just_pressed("ClearCameras"):
		reset_cameras()


func reset_cameras() -> void:
	cameras.clear()
	cameraid = 1
	clear_cameras.emit()


func set_current_camera(cameraID: int) -> void:
	currentcamera = cameraID
	print_debug("cameraid= " + str(currentcamera))
	use_camera.emit(currentcamera)


func register_camera() -> int:
	cameras.push_front(cameraid)
	cameraid += 1
	return cameraid - 1
