extends Node3D
var bob_speed: float = 5
var bob_dist: float = 0.002
var bob_index: float = 0.5
var bob_vector: Vector2 = Vector2.ZERO
@onready var pivot: Node3D = self
@onready var player: Node = $"../../../.."
@export var lerp_speed: float = 10
@onready var fps_rig: Node3D = %fps_rig
var offset: Transform3D
var mouse_input: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative


func _physics_process(delta: float) -> void:
	if player.input_dir != Vector2.ZERO and player.spectator_cam.current:
		bob_index += bob_speed * delta
		bob_vector.y = sin(bob_index)
		bob_vector.x = sin(bob_index) + 0.5
		pivot.rotation.z = lerp(
			pivot.rotation.z, bob_vector.x * bob_dist * player.speed, delta * lerp_speed
		)
		pivot.rotation.x = lerp(
			pivot.rotation.x, bob_vector.x * bob_dist * player.speed, delta * lerp_speed
		)
		pivot.rotation.y = lerp(
			pivot.rotation.y, bob_vector.x * bob_dist * player.speed, delta * lerp_speed
		)
		pivot.position.z = lerp(
			pivot.position.z, bob_vector.x * bob_dist * player.speed, delta * lerp_speed
		)
		pivot.position.x = lerp(
			pivot.position.x, bob_vector.x * bob_dist * player.speed, delta * lerp_speed
		)
	if Input.is_action_pressed("ADS"):
		pivot.rotation.x = lerp(
			pivot.rotation.x,
			(
				bob_vector.x
				* bob_dist
				* mouse_input.y
				* player.speed
				* (player.spectator_cam.current_fov / player.spectator_cam.max_fov)
				/ 10
			),
			delta * lerp_speed
		)
		pivot.rotation.y = lerp(
			pivot.rotation.y,
			(
				bob_vector.y
				* bob_dist
				* mouse_input.x
				* (player.spectator_cam.current_fov / player.spectator_cam.max_fov)
				* player.speed
				/ 10
			),
			delta * lerp_speed
		)
		pivot.rotation.z = lerp(pivot.rotation.z, 0.0, delta * lerp_speed / 5)
		pivot.position.z = lerp(pivot.position.z, 0.0, delta * lerp_speed / 5)
		pivot.position.x = lerp(pivot.position.x, 0.0, delta * lerp_speed / 5)
	elif player.spectator_cam.current:
		pivot.rotation.x = lerp(
			pivot.rotation.x,
			bob_vector.x * bob_dist * mouse_input.y * player.speed / 2,
			delta * lerp_speed
		)
		pivot.rotation.y = lerp(
			pivot.rotation.y,
			bob_vector.y * bob_dist * mouse_input.x * player.speed / 2,
			delta * lerp_speed
		)
