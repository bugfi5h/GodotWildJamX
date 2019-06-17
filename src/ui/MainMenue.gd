extends Control


func _on_BtnQuit_pressed() -> void:
	get_tree().quit()


func _on_BtnPlay_pressed() -> void:
	SceneLoader.goto_scene("res://map/MainMap.tscn")


func _on_BtnSettings_pressed() -> void:
	SceneLoader.goto_menu_scene("res://ui/Settings.tscn")
	pass # Replace with function body.
