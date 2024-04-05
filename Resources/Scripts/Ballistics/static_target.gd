extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_hit(bullet: NCBSHitRes):
	var bullet_res: NCBSBulletRes = bullet.BulletRes
	print("hitpos " + str(bullet.HitDict.position))
	var hit_vector = bullet.HitDict.position.direction_to(bullet.LastBulletPos.origin)
	#apply_impulse(hit_vector * 10, bullet.HitDict.position)
