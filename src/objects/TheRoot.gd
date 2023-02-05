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

func attach(root_anchor_pos: Vector2):
	attached = true
	$RootHandle.update_position = false
	$RootAnchor.global_position = root_anchor_pos
	$RootJoint.global_position = root_anchor_pos
	$RootJoint.node_b = $RootHandle.get_path()

func detach():
	$RootJoint.node_b = $RootAnchor.get_path()
	$RootHandle.update_position = true
	attached = false

func get_handle_velocity():
	return $RootHandle.linear_velocity

func is_attached():
	return attached
