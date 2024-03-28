extends CheckBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.button_pressed = SettingsManager.get_var("fps_counter")
	self.toggled.connect(toggle_FPS_counter)


func toggle_FPS_counter(toggle: bool)-> void:
	if toggle:
		SettingsManager.save_var("fps_counter", true)
	else:
		SettingsManager.save_var("fps_counter", false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
