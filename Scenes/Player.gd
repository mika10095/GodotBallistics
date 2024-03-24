extends CharacterBody3D

@export_range(0, 10, 0.01) var sensitivity: float = 3
@onready var spectator_cam = %PlayerCamera.get_node("Camera3D")
@onready var camera_pivot = %PlayerCamera
@onready var headbob_pivot = $HeadbobPivot
@onready var freelook_enabled: bool = !spectator_cam.freelook_enabled
const speed = 5.0
const jump_velocity = 4.5
@export var lerp_speed = 10
var direction = Vector3.ZERO
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bob_speed = 10
var bob_dist = 0.05
var bob_index = 0.5
var bob_vector = Vector2.ZERO


func _input(event):
	if Input.is_action_just_pressed("ChangeCameraMode"):
		if freelook_enabled:
			print_debug("freelook enabled!")
			spectator_cam.global_transform.origin = Vector3(0, 0, 0)
			camera_pivot.rotation.x = 0
			camera_pivot.rotation.z = 0
		else:
			pass
		spectator_cam.freelook_enabled = !spectator_cam.freelook_enabled
		freelook_enabled = !freelook_enabled
		spectator_cam.Reset()

	if freelook_enabled:
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				if event is InputEventMouseMotion:
					rotation.y -= event.relative.x / 1000 * sensitivity
					camera_pivot.rotation.x -= event.relative.y / 1000 * sensitivity
					camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, PI / -2, PI / 2)

		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	if freelook_enabled:
		# Add the gravity.

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
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

		if is_on_floor() and input_dir != Vector2.ZERO:
			bob_index += bob_speed * delta
			bob_vector.y = sin(bob_index)
			bob_vector.x = sin(bob_index / 2) + 0.5

			headbob_pivot.position.y = lerp(
				headbob_pivot.position.y, bob_vector.y * bob_dist / 2, delta * lerp_speed
			)
			headbob_pivot.position.x = lerp(
				headbob_pivot.position.x, bob_vector.x * bob_dist, delta * lerp_speed
			)
		else:
			headbob_pivot.position.y = lerp(headbob_pivot.position.y, 0.0, delta * lerp_speed)
			headbob_pivot.position.x = lerp(headbob_pivot.position.x, 0.0, delta * lerp_speed)
			bob_index = 0.5
		if not is_on_floor():
			velocity.y -= gravity * delta
		move_and_slide()
