extends Node3D

@export var weapon: Node3D
@onready var anim = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play(weapon.name + "_Equip")
