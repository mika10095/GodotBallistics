class_name SaveConfig extends Resource

@export var slider_settings = {"master_audio":1.0,"music_audio":1.0,"effect_audio":1.0,"ui_audio":1.0,"base_sens":3.0}
@export var window_setting: int = 0
@export var fps_counter: bool = false

func save() -> void:
	ResourceSaver.save(self, "res://config.tres")
	
	
static func load() -> SaveConfig:
	var conf: SaveConfig = load("res://config.tres") as SaveConfig
	if !conf:
		conf = SaveConfig.new()
	return conf
