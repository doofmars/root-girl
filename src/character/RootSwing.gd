extends Node2D

var root_shooting = false
var root_target = Vector2.ZERO
var root_has_hit = false
var root_length = 0
var ray_length = 400

export var VECTOR_SCALE = 400
export var root_speed = 2
export var root_max_length = 100

signal attach(root_target, root_length)
signal detach()

func _process(delta):
	if root_shooting and root_target != Vector2.ZERO and !root_has_hit:
		$RootSprite.look_at(root_target)
		$RootSprite.scale.x += root_speed * delta
		
		var velo = (root_target - $RootCollisionShape.global_position).normalized() * VECTOR_SCALE * root_speed * delta
		$RootCollisionShape.position += velo

	if root_has_hit:
		$RootSprite.look_at(root_target)
		$RootSprite.scale.x = (self.global_position - root_target).length()/411

func _input(event):
	if event is InputEventMouse:
		if root_has_hit:
			if event.is_action_released("swing"):
				root_has_hit = false
				root_target = Vector2.ZERO
				$RootSprite.scale.x=0
				emit_signal("detach")
		else:
			if event.is_action_pressed("swing"):
				shoot_root(event.position)

		# event = make_input_local(event)
		# ABT1.position = event.position

func shoot_root(position: Vector2):
	root_target = Vector2.ZERO

	var from = global_position
	var to = get_global_mouse_position()
	var direction = from.direction_to(to)
	to = (direction * ray_length) + from

	var space_state = get_world_2d().direct_space_state

	var result = space_state.intersect_ray(from, to, [self, get_parent()], 2, true, true)
	if result:
		print(from, position, result)
		root_shooting = true
		root_target = result.position

func _on_RootSwing_body_entered(_body:Node):
	if root_shooting:
		root_shooting = false
		root_has_hit = true
		root_length = (self.global_position - root_target).length()
		$RootCollisionShape.position = Vector2.ZERO
		emit_signal("attach", root_target, root_length)
