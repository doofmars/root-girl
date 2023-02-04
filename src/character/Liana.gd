extends Node2D

var liana_active = false
var liana_destination = Vector2.ZERO
var liana_has_hit = false

var SCALE_DIFFERENCE = 4.135

export var liana_speed = 1

func _process(delta):
	if liana_active and liana_destination != Vector2.ZERO and !liana_has_hit:
		$LianaSprite.look_at(liana_destination)
		$LianaSprite.scale.x += liana_speed * delta
		$CollisionShape2D.look_at(liana_destination)
		$CollisionShape2D.scale.x += liana_speed * delta * SCALE_DIFFERENCE

func _physics_process(_delta):
	if Input.is_action_pressed("liana"):
		var space_state = get_world_2d().direct_space_state

		# use global coordinates, not local to node
		var result = space_state.intersect_ray(position, get_viewport().get_mouse_position(), [self], 1, true, true)
		if result:
			liana_active = true
			liana_destination = result.position

func _on_Liana_area_entered(area:Area2D):
	print("_on_Liana_area_entered", area)
	liana_has_hit = true
	liana_active = true
	liana_destination = Vector2.ZERO
