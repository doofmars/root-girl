extends Node2D

var liana_active = false
var liana_destination = Vector2.ZERO
var liana_has_hit = false

export var VECTOR_SCALE = 400

export var liana_speed = 2

signal pull(liana_destination)

func _process(delta):
	if liana_active and liana_destination != Vector2.ZERO and !liana_has_hit:
		$LianaSprite.look_at(liana_destination)
		$LianaSprite.scale.x += liana_speed * delta
		
		var velo = (liana_destination - $LianaCollisionShape.global_position).normalized() * VECTOR_SCALE * liana_speed * delta
		$LianaCollisionShape.position += velo
	if liana_has_hit:
		$LianaSprite.look_at(liana_destination)
		$LianaSprite.scale.x = (self.global_position - liana_destination).length()/411

func _physics_process(_delta):
	if Input.is_action_pressed("liana"):
		if liana_has_hit:
			pull()
		else:
			shoot_liana()
			
func _on_Liana_area_shape_entered(_area_rid:RID, _area:Area2D, _area_shape_index:int, _local_shape_index:int):
	liana_active = false
	liana_has_hit = true

func shoot_liana():
	var space_state = get_world_2d().direct_space_state

	# use global coordinates, not local to node
	var result = space_state.intersect_ray(global_position, get_viewport().get_mouse_position(), [self, get_parent()], 2, true, true)
	if result:
		liana_active = true
		liana_destination = result.position

func pull():
	emit_signal("pull", liana_destination)