extends Control

@onready var menu = %PauseMenu
@onready var new_new_world = $"../.."


func _ready():
	%PauseMenu/BackButton.pressed.connect(on_menu_button)


func _input(_event):
	if Input.is_action_just_pressed("MenuButton"):
		menu.visible = !menu.visible
	if menu.visible:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false


func on_menu_button():
	new_new_world.queue_free()
	get_tree().root.add_child(load("res://Scenes/menu.tscn").instantiate())
	get_tree().paused = false
