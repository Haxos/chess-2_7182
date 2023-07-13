extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_game_pressed():
	$Board.new_board()
	$MenuMusic.stop()
	$Atmospheric.play()
	$Camera2D.rotation_degrees = 0
	$StartMenu.visible = false
	$Camera2D.enabled = true


func _on_board_next_turn():
	$Camera2D.rotation_degrees = fmod($Camera2D.rotation_degrees + 180, 360)
	for piece in get_tree().get_nodes_in_group("pieces"):
		piece.rotation_degrees = fmod(piece.rotation_degrees - 180, 360)


func _on_board_victory(_moves: int):
	print("victory")
	$Atmospheric.stop()
	$Camera2D.enabled = false
	$EndGameMenu/Lose.visible = false
	$EndGameMenu/Win.visible = true
	$EndGameMenu.visible = true
	$BackToStartMenuTimer.start()


func _on_board_defeat():
	print("defeat")
	$Atmospheric.stop()
	$Camera2D.enabled = false
	$EndGameMenu/Lose.visible = true
	$EndGameMenu/Win.visible = false
	$EndGameMenu.visible = true
	$BackToStartMenuTimer.start()


func _on_back_to_start_menu_timer_timeout():
	$EndGameMenu.visible = false
	$StartMenu.visible = true
	$MenuMusic.play()
