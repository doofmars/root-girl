extends Node

var starting_position
var girl

func _ready():
	girl = get_node("Girl")
	starting_position = girl.position
	
func _process(delta):
	if Input.is_action_pressed("action_restart"):
		notify_player_death()

func notify_player_death():
	girl.position = starting_position
	girl.velocity = Vector2.ZERO
	
func touch_flag():
	get_parent().level_finished(get_node(".").name)
