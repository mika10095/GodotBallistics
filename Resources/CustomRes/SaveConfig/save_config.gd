class_name SaveConfig extends Resource

@export var settings: Dictionary = {
	"master_audio": 0.5,
	"music_audio": 0.5,
	"effect_audio": 0.5,
	"ui_audio": 0.5,
	"base_sens": 0.3,
	"aim_sens": 0.1,
	"max_fov": 0.6,
	"min_fov": 0.15,
	"window_setting": 0,
	"fps_counter": false,
	"debug_lines": true,
	"MSAA_quality": 2,
	"Scope_quality": 2
}


func save() -> void:
	ResourceSaver.save(self, "res://config.tres")


static func load() -> SaveConfig:
	var conf: SaveConfig = load("res://config.tres") as SaveConfig
	if !conf:
		conf = SaveConfig.new()
	return conf
