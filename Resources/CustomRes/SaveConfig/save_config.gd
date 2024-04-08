class_name SaveConfig extends Resource
##ferike ez easy....
##
@export var settings: Dictionary = {
	"master_audio": 1.0,
	"music_audio": 1.0,
	"effect_audio": 1.0,
	"ui_audio": 1.0,
	"base_sens": 0.3,
	"aim_sens": 0.05,
	"max_fov": 0.6,
	"min_fov": 0.15,
	"window_setting": 0,
	"fps_counter": false,
	"debug_lines": true,
	"MSAA_quality": 2,
	"Scope_quality": 2048
}  ##ezek a változók amiket a menüben a saját slidereimmel csapok ki


func save() -> void:  ##ez a funkció elmenti a fostos beállításokak egy szöveges resource állományba
	ResourceSaver.save(self, "res://config.tres")


static func load() -> SaveConfig:  ##ez a funkció betölti a fostos beállításokak egy szöveges resource állományba vagy ha nincs létrehozza!
	var conf: SaveConfig = load("res://config.tres") as SaveConfig
	if !conf:
		conf = SaveConfig.new()
	return conf
