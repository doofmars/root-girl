extends Node

signal show_menu
signal game_time
signal death_count

var current_level
var millis_elapsed = 0
var deaths = 0

const levels = [
	"Tutorial1",
	"Tutorial2",
	"Tutorial3",
	"Tutorial4",
	"Plain", 
	"Basketball",
	"Dungeon",
	"LongSwingSpikes",
	"Spikes",
	"Whichpath",
]

func _on_Menu_run_game():
	if current_level == null:
		start_level(levels[0])
		millis_elapsed = 0
		deaths = 0
		emit_signal("death_count", deaths)
		get_node("GameTimer").start()
		$GameFinishedMusicPlayer.stop()
		
func _process(delta):
	if current_level != null and Input.is_action_pressed("action_pause"):
		emit_signal("show_menu", "Continue")

func level_finished(level_name):
	$LevelFinishedMusicPlayer.play(0)
	var index_of_next = levels.find(level_name) + 1
	if (index_of_next < levels.size()):
		start_level(levels[index_of_next])
	else:
		$GameFinishedMusicPlayer.play(0)
		current_level.queue_free()
		current_level = null
		get_node("GameTimer").stop()
		emit_signal("show_menu", "Restart")
	
func start_level(level_name):
	var level_scene = load("res://src/level/" + level_name + ".tscn")
	if current_level != null:
		current_level.queue_free()
	current_level = level_scene.instance()
	add_child(current_level)
	get_node("ScoreHUD").show()

func _on_GameTimer_timeout():
	millis_elapsed += 100
	var tenths = (millis_elapsed / 100) % 10
	var seconds = (millis_elapsed / 1_000) % 60
	var minutes = (millis_elapsed / 60_000) % 60
	var hours = millis_elapsed / 3_600_000

	var result: String = "%02d:%02d:%02d.%d" % [hours, minutes, seconds, tenths]
	while result.begins_with("00:"):
		result = result.substr(3)
	emit_signal("game_time", result)

func increment_death_count():
	deaths += 1
	emit_signal("death_count", deaths)
