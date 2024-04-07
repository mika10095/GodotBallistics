extends Node3D

@export var is_semi_auto: bool = true
@export var semi_auto_reset: bool = true
@export var is_current_weapon: bool = true
@export var is_animation_over: bool = true
@export var is_action_animation_over: bool = true
@export var ADS: bool = false
@export var animation_name: String = "Action"
@export var gun_model: Node3D
@onready var anim: AnimationPlayer = gun_model.get_node("AnimationPlayer")
@export var ray_length: float = 1000
@export var ready_to_fire: bool
@onready var fps_rig: Node = %fps_rig
@onready var weapon_sound: AudioStreamPlayer3D = gun_model.get_node("AudioStreamPlayer3D")
@export var NCBS_bullet: NCBSBulletRes
const muzzle_flash_prefab = preload("res://Resources/Models/Puska/muzzle_flash.tscn")

@export var accuracy_moa: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.animation_finished.connect(anim_end)


func anim_end(anim_name: String) -> void:
	print("Animation over: " + anim_name)
	if anim_name == animation_name:
		is_action_animation_over = true
	elif anim_name == gun_model.name + "_Aim":
		is_animation_over = true
	else:
		is_animation_over = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ADS") and !ADS and is_animation_over:
		print("Aimed playing: " + fps_rig.weapon.name + "_Aim")
		fps_rig.anim.play(fps_rig.weapon.name + "_Aim")
		is_animation_over = false
		ready_to_fire = false
		ADS = true
	elif ADS == true and !Input.is_action_pressed("ADS") and is_animation_over:
		fps_rig.anim.speed_scale = 1
		fps_rig.anim.play_backwards(fps_rig.weapon.name + "_Aim")
		is_animation_over = false
		ready_to_fire = false
		ADS = false
	if !fps_rig.anim.animation_finished.is_connected(anim_end):
		fps_rig.anim.animation_finished.connect(anim_end)
	#print_debug("FirePressed"+str(Input.is_action_pressed("FireCurrent"))+"\n"+"Semi"+str(semi_auto_reset)+"\n"+"Anim"+str(is_animation_over)+"\n"+"released"+str(Input.is_action_just_released("FireCurrent"))+"\n"+str(ready_to_fire))

	if is_current_weapon and semi_auto_reset and is_animation_over and is_action_animation_over:
		ready_to_fire = true

	if Input.is_action_just_released("FireCurrent"):
		semi_auto_reset = true


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("FireCurrent") and ready_to_fire:
		fire_round()


func fire_round() -> void:
	ready_to_fire = false
	is_action_animation_over = false
	if is_semi_auto:
		semi_auto_reset = false
	anim.play("Action")
	weapon_sound.play()

	if ADS:
		fps_rig.anim.play(fps_rig.weapon.name + "_Aim_Fire")
	else:
		fps_rig.anim.play(fps_rig.weapon.name + "_Equip_Fire")
	var firepoint: Transform3D = fps_rig.weapon.find_child("FirePoint").global_transform

	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var start: Vector3 = firepoint.origin
	var end: Vector3 = firepoint.origin + firepoint.basis.x * 100
	print(str(start) + " " + str(end))
	var query := PhysicsRayQueryParameters3D.create(start, end)
	#DebugTools.draw_line_color(start,end,Color.RED)
	var result := space.intersect_ray(query)
	if result:
		print_debug(result.collider.name)

	var flash = muzzle_flash_prefab.instantiate()
	get_tree().root.add_child(flash)
	flash.global_position = firepoint.origin
	flash.get_node("Flash").emitting = true
	NCBS.AddBullet(add_innacuracy_moa(firepoint, accuracy_moa), NCBS_bullet)
	#NCBS.AddBullet(firepoint, NCBS_bullet)


func add_innacuracy_moa(transform: Transform3D, innacuracy: float) -> Transform3D:
	var transformnew = transform.rotated(
		Vector3(0, 0, 1), randf_range(-0.0003 * accuracy_moa, 0.0003 * accuracy_moa)
	)
	transformnew = transformnew.rotated(
		Vector3(0, 1, 0), randf_range(-0.0003 * accuracy_moa, 0.0003 * accuracy_moa)
	)
	return transformnew
