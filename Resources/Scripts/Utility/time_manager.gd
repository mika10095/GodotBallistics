extends Node
@export var time_scale: float = 1.0
@export var min_scale: float = 0.01
@export var max_scale: float = 1.0


func set_time_scale(scale: float):
	time_scale = scale
	Engine.time_scale = clamp(time_scale, min_scale, max_scale)


func reset_time_scale():
	Engine.time_scale = 1.0
	time_scale = 1.0
