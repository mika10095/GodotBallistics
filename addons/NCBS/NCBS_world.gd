extends Node
@export_category("Gravity")
@export var gravityconstantdir: Vector3 = Vector3(0, -1, 0)
@export var gravityconstantforce: float = 9.8
@export_category("Air Resistance")
#test only replace with actual later
@export var atmospheric_pressure: float = 101325
@export var atmospheric_density: float = 1.225


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
