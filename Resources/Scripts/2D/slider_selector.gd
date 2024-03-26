extends HBoxContainer
@onready var slider: HSlider = $HSlider
@onready var text: LineEdit = $LineEdit
@onready var label: Label = $Label
@export var slider_setting_name:String
@export var multiplier:float = 100
var config = SaveConfig.load()
@onready var Menu: Node = %Menu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider.drag_ended.connect(update_text.bind().unbind(1))
	text.text_changed.connect(update_slider.bind().unbind(1))
	slider.value = config.slider_settings[slider_setting_name]
	label.text=slider_setting_name.capitalize()
	update_text()
	update_slider()
func update_text() -> void:
	text.text = str(slider.value*multiplier)
	Menu.slider_value_changed(slider_setting_name,slider)
func update_slider() -> void:
	slider.value = float(text.text)/multiplier
	Menu.slider_value_changed(slider_setting_name,slider)
