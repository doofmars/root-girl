extends CanvasLayer

signal run_game

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		go_to_game()

func _on_StartButton_pressed():
	go_to_game()
	
func go_to_game():
	get_tree().paused = false
	hide()
	emit_signal("run_game")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Game_show_menu(text):
	get_tree().paused = true
	$StartButton.text = text
	show()
