extends Node

signal show_menu

var current_level

const levels = [
	"Plain", 
	"Basketball"
]

func _on_Menu_run_game():
	if current_level == null:
		start_level(levels[0])
		
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("show_menu")

func level_finished(level_name):
	var index_of_current = levels.find(level_name)
	start_level(levels[index_of_current + 1])
	
func start_level(level_name):
	var level_scene = load("res://src/level/" + level_name + ".tscn")
	if current_level != null:
		current_level.queue_free()
	current_level = level_scene.instance()
	add_child(current_level)
