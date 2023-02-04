extends Area2D

func _on_EndFlag_body_entered(body):
	if body.get_meta('type') == 'girl':
		print("touched flag!")
		var parent = get_parent().touch_flag()
