extends Node3D

@onready var anim = get_node("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	anim.play("Action")
