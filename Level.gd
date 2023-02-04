extends Node

var starting_position
var girl

const LIMIT_LEFT = 0
const LIMIT_TOP = 0
const LIMIT_BOTTOM = 360

func _ready():
	girl = get_node("Girl")
	starting_position = girl.position
	
	var map = self.get_node("TileMap")
	var rect = map.get_used_rect()
	
	for child in get_children():
		if child is Girl:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = rect.end.x * map.cell_quadrant_size
			camera.limit_bottom = LIMIT_BOTTOM

func _process(delta):
	if Input.is_action_pressed("action_restart"):
		notify_player_death()

func notify_player_death():
	girl.position = starting_position
	girl.velocity = Vector2.ZERO
	get_parent().increment_death_count()
	
func touch_flag():
	get_parent().level_finished(get_node(".").name)
