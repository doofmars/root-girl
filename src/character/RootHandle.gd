class_name RootHandle
extends RigidBody2D

export var desired_position: Vector2 = Vector2.ZERO
export var update_position = true

func _integrate_forces(state):
	if (update_position):
		var newTransform = Transform2D(0, desired_position)
		state.linear_velocity = Vector2.ZERO
		state.transform = newTransform
