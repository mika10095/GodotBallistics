extends Node
const gravityconst: float = 9.8

func calculate(trans: Transform3D, vel: float) -> Transform3D:
	return Transform3D()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("new projectile ready!") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
