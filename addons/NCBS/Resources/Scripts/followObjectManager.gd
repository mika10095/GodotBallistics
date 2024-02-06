extends Node
signal use_camera
signal clear_cameras
var cameraid: int = 1
var currentcamera: int = 1
# Called when the node enters the scene tree for the first time.
func _unhandled_key_input(event: InputEvent) -> void:
	var key = event.as_text()
	if key.length() > 1:
		if key.begins_with('F'):
			print_debug(key)
			use_camera.emit(key)
	if Input.is_action_just_pressed("NextCamera"):
		currentcamera+=1
		use_camera.emit("F" + str(currentcamera))
		
	if Input.is_action_just_pressed("PreviousCamera"):
		currentcamera-=1
		use_camera.emit("F" + str(currentcamera))
	if Input.is_action_just_pressed("ClearCameras"):
		cameraid = 2
		clear_cameras.emit()

func set_current_camera(cameraID: int):
		currentcamera = cameraID
		print_debug("cameraid= " + str(currentcamera))
func register_camera() -> int:
		cameraid+=1
		return cameraid-1
		
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
