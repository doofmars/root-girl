extends Node2D

var liana_shooting = false
var liana_target = Vector2.ZERO
var liana_has_hit = false
var liana_length = 0;

export var VECTOR_SCALE = 400
export var liana_speed = 2
export var liana_max_length = 100

signal swing(delta, liana_target, liana_length)

func _process(delta):
	if liana_shooting and liana_target != Vector2.ZERO and !liana_has_hit:
		$LianaSprite.look_at(liana_target)
		$LianaSprite.scale.x += liana_speed * delta
		
		var velo = (liana_target - $LianaCollisionShape.global_position).normalized() * VECTOR_SCALE * liana_speed * delta
		$LianaCollisionShape.position += velo

	if liana_has_hit:
		$LianaSprite.look_at(liana_target)
		$LianaSprite.scale.x = (self.global_position - liana_target).length()/411

func _physics_process(delta):
	if liana_has_hit:
		if Input.is_action_just_released("liana"):
			liana_has_hit = false
			liana_target = Vector2.ZERO
			$LianaSprite.scale.x=0
		swing(delta)
	else:
		if Input.is_action_just_pressed("liana"):
			shoot_liana()
			
			
func _on_Liana_area_shape_entered(_area_rid:RID, _area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if liana_shooting:
		liana_shooting = false
		liana_has_hit = true
		liana_length = (self.global_position - liana_target).length()
		$LianaCollisionShape.position = Vector2.ZERO
	

func shoot_liana():
	var space_state = get_world_2d().direct_space_state

	# use global coordinates, not local to node
	var result = space_state.intersect_ray(global_position, get_viewport().get_mouse_position(), [self, get_parent()], 2, true, true)
	if result:
		liana_shooting = true
		liana_target = result.position

func swing(delta):
	emit_signal("swing", delta, liana_target, liana_length)
