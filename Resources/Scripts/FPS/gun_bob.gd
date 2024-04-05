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


func _physics_process(delta: float) -> void:
	if player.input_dir != Vector2.ZERO:
		bob_index += bob_speed * delta
		bob_vector.y = sin(bob_index)
		bob_vector.x = sin(bob_index) + 0.5
		pivot.rotation.z = lerp(
			pivot.rotation.z, bob_vector.x * bob_dist * player.speed, delta * lerp_speed
		)
		pivot.rotation.x = lerp(
			pivot.rotation.x, bob_vector.x * bob_dist * player.speed * 2, delta * lerp_speed
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
	else:
		pivot.rotation.y = lerp(pivot.rotation.y, 0.0, delta * lerp_speed)
		pivot.rotation.x = lerp(pivot.rotation.x, 0.0, delta * lerp_speed)
		pivot.rotation.z = lerp(pivot.rotation.z, 0.0, delta * lerp_speed)
		pivot.position.z = lerp(pivot.position.z, 0.0, delta * lerp_speed)
		pivot.position.x = lerp(pivot.position.x, 0.0, delta * lerp_speed)
		bob_index = 0.5
