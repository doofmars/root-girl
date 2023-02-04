extends Area2D

func _on_EndFlag_body_entered(body):
	if body.get_meta('type') == 'girl':
		var parent = get_parent().touch_flag()

func _ready():
	self.get_node("AnimationPlayer").play("Flag")
