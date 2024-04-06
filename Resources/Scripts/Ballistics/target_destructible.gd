extends RigidBody3D
@export var force_multiplier: float = 1
@export var flip_force: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_hit(bullet: NCBSHitRes):
	var bullet_res: NCBSBulletRes = bullet.BulletRes
	var hit_position: Vector3 = bullet.HitDict.position
	var bullet_direction = (hit_position - bullet.LastBulletPos.origin).normalized()
	apply_impulse(
		bullet_direction * joule_to_meters(bullet.HitPowerJoules, bullet_res) * force_multiplier,
		hit_position - global_position
	)

	DebugTools.draw_sphere(hit_position)
	print("hitpos " + str(hit_position) + "\n" + "hit vector: " + str(bullet_direction))

	#var speed = joule_to_meters(bullet.HitPowerJoules, bullet_res)
	get_parent().queue_free()


func joule_to_meters(joules: float, bullet_data: NCBSBulletRes) -> float:
	#joules = 0.5f * Data.BulletMass * (float)Math.Pow(CurrentState.Velocity.X + CurrentState.Velocity.Z, 2);
	print_debug(joules)
	var velocity = sqrt(joules / 0.5 / bullet_data.BulletMass)
	print_debug(velocity)
	return velocity
