extends Node
@export var UI_root: NodePath
@onready var sound_dictionary: Dictionary = {
	&"UI_click": AudioStreamPlayer.new(), &"UI_click_soft": AudioStreamPlayer.new()
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sound: StringName in sound_dictionary.keys():
		sound_dictionary[sound].stream = load("res://Resources/Audio/SFX/" + str(sound) + ".wav")
		sound_dictionary[sound].bus = "Ui"
		add_child(sound_dictionary[sound])
	add_sound_players(get_node(UI_root))


func add_sound_players(node: Node) -> void:
	for i in node.get_children():
		#print_debug(i)
		if i is Button:
			i.pressed.connect(play_sound.bind(&"UI_click"))
			i.mouse_entered.connect(play_sound.bind(&"UI_click_soft"))
		elif i is Slider:
			i.mouse_entered.connect(play_sound.bind(&"UI_click_soft"))
			i.drag_started.connect(play_sound.bind(&"UI_click_soft"))
			i.drag_ended.connect(play_sound.bind(&"UI_click").unbind(1))
		add_sound_players(i)


func play_sound(sound: StringName) -> void:
	sound_dictionary[sound].play()
