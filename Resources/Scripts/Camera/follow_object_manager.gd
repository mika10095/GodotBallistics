extends Node
signal use_camera
signal clear_cameras
var cameraid: int = 0
var cameras: Array = []
var currentcamera: int = 0


# Called when the node enters the scene tree for the first time.
func _unhandled_key_input(event: InputEvent) -> void:
	var key: String = event.as_text()
	if key.length() > 1:
		if key.begins_with("F"):
			if cameras.has(int(key)):
				print_debug(key)
				use_camera.emit(key)
			else:
				print_debug("invalid camera id")
	if Input.is_action_just_pressed("NextCamera"):
		if cameras.has(currentcamera + 1):
			currentcamera += 1
			use_camera.emit("F" + str(currentcamera))
		else:
			print_debug("invalid camera id")

	if Input.is_action_just_pressed("PreviousCamera"):
		if cameras.has(currentcamera - 1):
			currentcamera -= 1
			use_camera.emit("F" + str(currentcamera))
		else:
			print_debug("invalid camera id")
	if Input.is_action_just_pressed("ClearCameras"):
		cameras.clear()
		cameraid = 0
		clear_cameras.emit()


func set_current_camera(cameraID: int) -> void:
	currentcamera = cameraID
	print_debug("cameraid= " + str(currentcamera))


func register_camera() -> int:
	cameras.push_front(cameraid)
	cameraid += 1
	return cameraid - 1
