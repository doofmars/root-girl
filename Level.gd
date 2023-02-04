extends Node
	
func touch_flag():
	get_parent().level_finished(get_node(".").name)
