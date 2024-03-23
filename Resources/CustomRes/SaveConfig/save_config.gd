class_name SaveConfig extends Resource

@export_range(0, 1, .01) var master_audio: float = 1
@export_range(0, 1, .01) var music_audio: float = 1
@export_range(0, 1, .01) var effect_audio: float = 1
@export_range(0, 1, .01) var ui_audio: float = 1
@export var window_setting: int = 0
@export var fps_counter: bool = false


func save() -> void:
	ResourceSaver.save(self, "res://config.tres")
	
	
static func load() -> SaveConfig:
	var conf: SaveConfig = load("res://config.tres") as SaveConfig
	if !conf:
		conf = SaveConfig.new()
	return conf
