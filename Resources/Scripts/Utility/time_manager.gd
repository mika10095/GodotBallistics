extends Node
@export var time_scale: float = 1.0
@export var min_scale: float = 0.015
@export var max_scale: float = 1.0


func set_time_scale(scale: float) -> void:
	time_scale = scale
	Engine.time_scale = clamp(time_scale, min_scale, max_scale)
	Engine.physics_ticks_per_second = clamp(60 * clamp(time_scale, min_scale, max_scale), 1, 60)


func reset_time_scale() -> void:
	Engine.time_scale = 1.0
	Engine.physics_ticks_per_second = 60
	time_scale = 1.0
