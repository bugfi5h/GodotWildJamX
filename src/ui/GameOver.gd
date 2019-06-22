extends Control

func _ready() -> void:
	$MarginContainer/HBoxContainer/MarginContainer/Labels/HBoxContainer/HighScore.text = String(GameState.highscore)


func _on_BtnQuit_pressed() -> void:
	GameState.reset_game()
	SceneLoader.goto_menu_scene("res://ui/MainMenue.tscn")
