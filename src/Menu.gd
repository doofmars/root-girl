extends CanvasLayer

signal run_game

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		go_to_game()
	if Input.is_action_pressed("action_quit"):
		get_tree().quit()

func _on_StartButton_pressed():
	go_to_game()
	
func go_to_game():
	get_tree().paused = false
	hide()
	switchMusic(false)
	emit_signal("run_game")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Game_show_menu(text):
	get_tree().paused = true
	$StartButton.text = text
	switchMusic(true)
	show()

func switchMusic(paused):
	var levelMusicPlayer = get_node("../LevelMusicPlayer")
	var menuMusicPlayer = get_node("../MenuMusicPlayer")

	if paused:
		levelMusicPlayer.stop()
		menuMusicPlayer.play(levelMusicPlayer.get_playback_position())
	else:
		menuMusicPlayer.stop()
		levelMusicPlayer.play(menuMusicPlayer.get_playback_position())


func _on_CreditsButton_pressed():
	self.visible = false
	$Credits.visible = true
