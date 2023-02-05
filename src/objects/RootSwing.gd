extends Node2D

var root_shooting = false
var root_target = Vector2.ZERO
var root_has_hit = false
var root_length = 0
var ray_length = 400

export var VECTOR_SCALE = 400
export var root_groth = 800
export var root_speed = 10
export var root_max_length = 300

signal attach(root_target)
signal detach()

onready var root_handle: RootHandle = get_parent()

func _process(delta):
	if root_shooting and root_target != Vector2.ZERO and !root_has_hit:
		$RootSprite.look_at(root_target)
		var current_region = $RootSprite.region_rect
		var current_length = $RootSprite.region_rect.size.x
		var length = current_length + root_groth * delta
		
		if length > (root_handle.global_position - root_target).length():
			length = (root_handle.global_position - root_target).length()
		
		$RootSprite.region_rect.size.x = length
		
		var velo = (root_target - $RootCollisionShape.global_position).normalized() * VECTOR_SCALE * root_speed * delta
		$RootCollisionShape.position += velo
		if !$RootGrowMusicPlayer.playing:
			$RootGrowMusicPlayer.playing = true

	if root_has_hit:
		$RootSprite.look_at(root_target)
		$RootSprite.region_rect.size.x = (root_handle.global_position - root_target).length()

func _input(event):
	if event is InputEventMouse:
		if root_has_hit:
			if event.is_action_released("swing"):
				detach_root()
		else:
			if event.is_action_pressed("swing"):
				shoot_root(event.position)

func detach_root():
	root_has_hit = false
	root_shooting = false
	root_target = Vector2.ZERO
	$RootSprite.region_rect.size.x = 0
	emit_signal("detach")

func shoot_root(position: Vector2):
	root_target = Vector2.ZERO

	var from = global_position
	var to = get_global_mouse_position()
	var direction = from.direction_to(to)
	to = (direction * ray_length) + from

	var space_state = get_world_2d().direct_space_state

	var result = space_state.intersect_ray(from, to, [root_handle, get_parent()], 2, true, true)
	if result:
		# print(from, position, result)
		root_shooting = true
		root_target = result.position

func _on_RootSwing_body_entered(_body:Node):
	if root_shooting:
		$RootGrowMusicPlayer.playing = false
		$RootHitMusicPlayer.play(0)
		root_shooting = false
		root_has_hit = true
		$RootCollisionShape.position = Vector2.ZERO
		emit_signal("attach", root_target)
