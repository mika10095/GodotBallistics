extends RigidBody3D
signal target_hit
@export var force_multiplier: float = 1
@export var flip_force: bool = false
var decal_s = load("res://Resources/Models/Universal/bullet_decal.tscn")
var audio: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
var sound = preload("res://Resources/Audio/MetalHitSounds/MetalHit3.wav")
@export var sound_override: AudioStreamWAV


# Called when the node enters the scene tree for the first time.
func _ready():
	if sound_override:
		sound = sound_override
	audio.bus = "Effect"
	audio.stream = sound
	add_child(audio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_hit(bullet: NCBSHitRes):
	print_debug("Target hit")
	print_debug(bullet.HitID)
	emit_signal("target_hit")
	audio.play()
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
	#play sound

	#bullet decals
	var decal_normal = bullet.HitDict.normal
	var decal = decal_s.instantiate()
	bullet.HitDict.collider.add_child(decal)
	decal.global_transform.origin = hit_position
	if decal_normal == Vector3.DOWN:
		decal.rotation_degrees.x = 90
	elif decal_normal != Vector3.UP:
		decal.look_at(hit_position - decal_normal, Vector3(0, 1, 0))


func joule_to_meters(joules: float, bullet_data: NCBSBulletRes) -> float:
	#joules = 0.5f * Data.BulletMass * (float)Math.Pow(CurrentState.Velocity.X + CurrentState.Velocity.Z, 2);
	print_debug(joules)
	var velocity = sqrt(joules / 0.5 / bullet_data.BulletMass)
	print_debug(velocity)
	return velocity
