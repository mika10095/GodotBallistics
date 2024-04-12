extends Node3D
@onready var timer = $Timer
@onready var camera_follow = $CameraFollow


func _ready():
	FollowObjectManager.set_current_camera(camera_follow.id)


func destroy():
	timer.start()
	await timer.timeout
	if camera_follow.camera.current:
		FollowObjectManager.set_current_camera(1)
	queue_free()
