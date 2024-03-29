@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("NCBSBullet", "Node3D", preload("NCBS_bullet.gd"), preload("icon.png"))
	add_custom_type("NCBSBullet", "Node3D", preload("NCBS_bullet.gd"), preload("icon.png"))
	add_autoload_singleton("NCBSWorld", "res://addons/NCBS/NCBS_world.gd")


func _exit_tree():
	remove_custom_type("NCBSBullet")
	remove_autoload_singleton("NCBSWorld")
