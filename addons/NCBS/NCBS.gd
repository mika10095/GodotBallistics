@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("NCBS_world", "Node3D", preload("NCBS_world.gd"), preload("icon.png"))
	add_autoload_singleton("NCBS", "res://addons/NCBS/NCBS.cs")


func _exit_tree():
	remove_custom_type("NCBS_world")
	remove_autoload_singleton("NCBS")
