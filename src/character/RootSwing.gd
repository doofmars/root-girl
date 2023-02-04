extends Node2D

var root_shooting = false
var root_target = Vector2.ZERO
var root_has_hit = false
var root_length = 0;

export var VECTOR_SCALE = 400
export var root_speed = 2
export var root_max_length = 100

signal swing(delta, root_target, root_length)

func _process(delta):
	if root_shooting and root_target != Vector2.ZERO and !root_has_hit:
		$RootSprite.look_at(root_target)
		$RootSprite.scale.x += root_speed * delta
		
		var velo = (root_target - $RootCollisionShape.global_position).normalized() * VECTOR_SCALE * root_speed * delta
		$RootCollisionShape.position += velo

	if root_has_hit:
		$RootSprite.look_at(root_target)
		$RootSprite.scale.x = (self.global_position - root_target).length()/411

func _physics_process(delta):
	if root_has_hit:
		if Input.is_action_just_released("liana"):
			root_has_hit = false
			root_target = Vector2.ZERO
			$RootSprite.scale.x=0
		swing(delta)
	else:
		if Input.is_action_just_pressed("liana"):
			shoot_root()

func shoot_root():
	var space_state = get_world_2d().direct_space_state

	# use global coordinates, not local to node
	var result = space_state.intersect_ray(global_position, get_viewport().get_mouse_position(), [self, get_parent()], 2, true, true)
	if result:
		root_shooting = true
		root_target = result.position

func swing(delta):
	emit_signal("swing", delta, root_target, root_length)


func _on_RootSwing_area_shape_entered(_area_rid:RID, _area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if root_shooting:
		root_shooting = false
		root_has_hit = true
		root_length = (self.global_position - root_target).length()
		$RootCollisionShape.position = Vector2.ZERO
