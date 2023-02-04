extends Node

var current_level
var root_node

func _ready():
	root_node = get_tree().get_root()

func _on_Menu_run_game():
	get_tree().change_scene("res://src/level/level0.tscn")
