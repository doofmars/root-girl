extends Node2D

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)


func _physics_process(delta):
	if Input.is_action_pressed("liana"):
		var space_state = get_world_2d().direct_space_state
		
		# use global coordinates, not local to node
		var result = space_state.intersect_ray(position, get_viewport().get_mouse_position(), [], 1, true, true)
		print(result)
