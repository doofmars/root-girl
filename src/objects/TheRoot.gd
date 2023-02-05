class_name TheRoot
extends Node

var attached = false
const SWING_FORCE = 5

func _physics_process(delta):
	if attached:
		if Input.get_action_strength("move_right") > 0:
			$RootHandle.apply_impulse(Vector2.ZERO, Vector2.RIGHT * SWING_FORCE)
		if Input.get_action_strength("move_left") > 0:
			$RootHandle.apply_impulse(Vector2.ZERO, Vector2.LEFT * SWING_FORCE)

func on_player_move(position: Vector2):
	$RootHandle.desired_position = position

func attach(root_anchor_pos: Vector2, player_velocity: Vector2):
	attached = true
	var root_vector: Vector2 = (root_anchor_pos - $RootHandle.global_position).normalized()
	var swing_vector: Vector2
	if (root_vector.x > 0):
		swing_vector = root_vector.rotated(PI/4)
	else:
		swing_vector = root_vector.rotated(-PI/4)
	$RootHandle.update_position = false
	$RootAnchor.global_position = root_anchor_pos
	$RootJoint.global_position = root_anchor_pos
	$RootJoint.node_b = $RootHandle.get_path()
	$RootHandle.apply_impulse(Vector2.ZERO, swing_vector * cos(swing_vector.angle_to(player_velocity)) * player_velocity.length())

func detach():
	$RootJoint.node_b = $RootAnchor.get_path()
	$RootHandle.update_position = true
	attached = false

func get_handle_velocity():
	return $RootHandle.linear_velocity

func is_attached():
	return attached
