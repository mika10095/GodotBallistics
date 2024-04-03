extends Node

@export var World: NCBSWorldRes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NCBS.SetWorld(World)
