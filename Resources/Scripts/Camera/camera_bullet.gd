extends Node3D
@onready var timer: Node = $Timer
@onready var camera_follow: Node3D = $CameraFollow
@onready var bullet_mesh: MeshInstance3D = $bullet


func _ready() -> void:
	if SettingsManager.get_var("bullet_follow"):
		timer.wait_time = SettingsManager.get_var("bullet_follow_start")
		timer.start()
		await timer.timeout
		FollowObjectManager.set_current_camera(camera_follow.id)


func destroy() -> void:
	bullet_mesh.visible = false
	timer.wait_time = SettingsManager.get_var("bullet_follow_end")
	timer.start()
	await timer.timeout
	if camera_follow.camera.current:
		FollowObjectManager.set_current_camera(1)
	queue_free()
