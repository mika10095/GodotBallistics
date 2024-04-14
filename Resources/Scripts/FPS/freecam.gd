class_name Player extends CharacterBody3D

@export_range(0, 10, 0.01) var sensitivity: float
@export_range(0, 10, 0.01) var aim_sens: float = 1
@export_range(0, 10, 0.01) var base_sens: float = 3

@export var speed: float = 5.0
@export var default_speed: float = 5.0
@export var aim_speed: float = 1.0
@export var jump_velocity: float = 2.5

@onready var spectator_cam: Node = %PlayerCamera.get_node("Camera3D")
@onready var camera_pivot: Node = %PlayerCamera
@onready var headbob_pivot: Node = $HeadbobPivot

@onready var freelook_enabled: bool = !spectator_cam.freelook_enabled

@export var lerp_speed: float = 10
var direction: Vector3 = Vector3.ZERO
var input_dir: Vector2 = Vector2.ZERO

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var bob_speed: float = 10
var bob_dist: float = 0.01
var bob_index: float = 0.5
var bob_vector: Vector2 = Vector2.ZERO

var config: SettingsManager = SettingsManager


func _ready() -> void:
	base_sens = config.get_var("base_sens") * 10
	aim_sens = config.get_var("aim_sens") * 10
	sensitivity = base_sens


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ADS"):
		sensitivity = aim_sens
		speed = aim_speed
	else:
		sensitivity = base_sens
		speed = default_speed
	if Input.is_action_just_pressed("ChangeCameraMode") and spectator_cam.current:
		#if freelook_enabled:
		#print_debug("freelook enabled!")
		#spectator_cam.global_transform.origin = Vector3(0, 0, 0)
		#camera_pivot.rotation.x = 0
		#camera_pivot.rotation.z = 0
		#spectator_cam.freelook_enabled = !freelook_enabled
		#freelook_enabled = !spectator_cam.freelook_enabled
		#spectator_cam.Reset()
		print_debug(
			"bullet_follow mode changed to " + str(SettingsManager.get_var("bullet_follow"))
		)
		SettingsManager.save_var("bullet_follow", !SettingsManager.get_var("bullet_follow"))

	if freelook_enabled and spectator_cam.current:
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				if event is InputEventMouseMotion:
					rotation.y -= (
						event.relative.x
						/ 1000
						* sensitivity
						* (spectator_cam.current_fov / spectator_cam.max_fov)
					)
					camera_pivot.rotation.x -= (
						event.relative.y
						/ 1000
						* sensitivity
						* (spectator_cam.current_fov / spectator_cam.max_fov)
					)
					camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, PI / -2, PI / 2)

		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if freelook_enabled and spectator_cam.current:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = jump_velocity
		input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
		direction = (lerp(
			direction,
			(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
			delta * lerp_speed
		))

		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

		if Input.is_action_pressed("Sprint"):
			velocity *= 1.5

		if is_on_floor() and input_dir != Vector2.ZERO and spectator_cam.current:
			bob_index += bob_speed * delta
			bob_vector.y = sin(bob_index)
			bob_vector.x = sin(bob_index / 2) + 0.5

			headbob_pivot.position.y = lerp(
				headbob_pivot.position.y, bob_vector.y * bob_dist / 2 * speed, delta * lerp_speed
			)
			headbob_pivot.position.x = lerp(
				headbob_pivot.position.x, bob_vector.x * bob_dist * speed, delta * lerp_speed
			)
		else:
			headbob_pivot.position.y = lerp(headbob_pivot.position.y, 0.0, delta * lerp_speed)
			headbob_pivot.position.x = lerp(headbob_pivot.position.x, 0.0, delta * lerp_speed)
			bob_index = 0.5
	if !spectator_cam.current:
		velocity = Vector3(0, velocity.y, 0)
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
