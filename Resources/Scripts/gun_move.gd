extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.z += float(Input.is_physical_key_pressed(KEY_UP))*delta*0.1 - float(Input.is_physical_key_pressed(KEY_DOWN))*delta*0.1
	rotation.y += float(Input.is_physical_key_pressed(KEY_LEFT))*delta*0.1 - float(Input.is_physical_key_pressed(KEY_RIGHT))*delta*0.1
	rotation.z = clamp(rotation.z, PI/-2, PI/2)
