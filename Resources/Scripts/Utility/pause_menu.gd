extends Control

@onready var menu: Node = %PauseMenu
@onready var new_new_world: Node = $"../.."


func _ready() -> void:
	#%PauseMenu/BackButton.pressed.connect(on_menu_button)
	FollowObjectManager.reset_cameras()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("MenuButton"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		FollowObjectManager.reset_cameras()
		new_new_world.queue_free()
		get_tree().root.add_child(preload("res://Scenes/menu.tscn").instantiate())


#		menu.visible = !menu.visible
#	if menu.visible:
#		get_tree().paused = true
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	else:
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#		get_tree().paused = false


func on_menu_button() -> void:
	new_new_world.queue_free()
	get_tree().root.add_child(preload("res://Scenes/menu.tscn").instantiate())
	get_tree().paused = false
