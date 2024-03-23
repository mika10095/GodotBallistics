extends Camera3D

@export_range(0, 10, 0.01) var sensitivity: float = 3
@export_range(0, 1000, 0.1) var default_speed: float = 5
@export_range(0, 10, 0.01) var speed_scale: float = 1.1
@export var max_speed: float = 250
@export var min_speed: float = 0.1
@onready var current_speed = default_speed


func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x / 1000 * sensitivity
			rotation.x -= event.relative.y / 1000 * sensitivity
			rotation.x = clamp(rotation.x, PI / -2, PI / 2)
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(
					Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE
				)

	if Input.is_action_pressed("ZoomPos"):
		current_speed = clamp(current_speed * speed_scale, min_speed, max_speed)
	if Input.is_action_pressed("ZoomNeg"):
		current_speed = clamp(current_speed / speed_scale, min_speed, max_speed)


func _process(delta):
	var movedir = (
		Vector3(
			Input.get_axis("Left", "Right"),
			Input.get_axis("Crouch", "Jump"),
			Input.get_axis("Forward", "Backward")
		)
		. normalized()
	)

	translate(movedir * current_speed * delta)
