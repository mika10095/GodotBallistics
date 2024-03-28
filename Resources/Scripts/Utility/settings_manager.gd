extends Node

var config: SaveConfig = SaveConfig.load()


func save_var(setting_name: String, value:) -> void:
	config.settings[setting_name] = value
	config.save()
	

func get_var(setting_name: String):
	config = SaveConfig.load()
	return config.settings[setting_name]
