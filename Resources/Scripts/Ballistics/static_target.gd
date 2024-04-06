extends StaticBody3D

var decal_s = preload("res://Resources/Models/Universal/bullet_decal.tscn")
const sound = preload("res://Resources/Audio/MetalHitSounds/MetalHit3.wav")
var audio: AudioStreamPlayer3D = AudioStreamPlayer3D.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	audio.bus = "Effect"
	audio.stream = sound
	add_child(audio)


func handle_hit(bullet: NCBSHitRes):
	audio.play()
	var hit_position: Vector3 = bullet.HitDict.position

	DebugTools.draw_sphere(hit_position)
	var decal = decal_s.instantiate()
	var decal_normal = bullet.HitDict.normal
	bullet.HitDict.collider.add_child(decal)
	decal.global_transform.origin = hit_position
	if decal_normal == Vector3.DOWN:
		decal.rotation_degrees.x = 90
	elif decal_normal != Vector3.UP:
		decal.look_at(hit_position - decal_normal, Vector3(0, 1, 0))
