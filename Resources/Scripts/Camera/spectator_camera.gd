extends Camera3D

@export_range(0, 10, 0.01) var sensitivity: float = 3
@export_range(0, 1000, 0.1) var default_speed: float = 5
@export_range(0, 10, 0.01) var speed_scale: float = 1.1
@export_range(0, 10, 0.01) var default_camera_fov: float = 60
@export var min_speed: float = 0.1
@export var max_speed: float = 250
@export var min_fov: float = 10
@export var max_fov: float = 60
@onready var current_speed: float = default_speed
@onready var current_fov: float = default_camera_fov
@onready var freelook_enabled: bool = false


func Reset() -> void:
	self.transform = Transform3D.IDENTITY
	current_speed = default_speed
	current_fov = default_camera_fov


func _input(event: InputEvent) -> void:
	if freelook_enabled:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				rotation.y -= event.relative.x / 1000 * sensitivity
				rotation.x -= event.relative.y / 1000 * sensitivity
				rotation.x = clamp(rotation.x, PI / -2, PI / 2)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_pressed("ZoomPos"):
		current_fov = clamp(current_fov / speed_scale, min_fov, max_fov)
		self.fov = current_fov
	elif Input.is_action_pressed("TimeScaleUp"):
		TimeManager.set_time_scale(TimeManager.time_scale * speed_scale)
		print_debug(Engine.time_scale)
	elif Input.is_action_pressed("SpeedUp"):
		current_speed = clamp(current_speed * speed_scale, min_speed, max_speed)

	if Input.is_action_pressed("ZoomNeg"):
		current_fov = clamp(current_fov * speed_scale, min_fov, max_fov)
		self.fov = current_fov
	elif Input.is_action_pressed("TimeScaleDown"):
		TimeManager.set_time_scale(TimeManager.time_scale / speed_scale)
		print_debug(Engine.time_scale)
	elif Input.is_action_pressed("SpeedDown"):
		current_speed = clamp(current_speed / speed_scale, min_speed, max_speed)


func _process(delta: float) -> void:
	if freelook_enabled:
		var movedir: Vector3 = (
			Vector3(
				Input.get_axis("Left", "Right"),
				Input.get_axis("Crouch", "Jump"),
				Input.get_axis("Forward", "Backward")
			)
			. normalized()
		)
		translate(movedir * current_speed * delta)
