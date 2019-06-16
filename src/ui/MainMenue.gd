extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_BtnQuit_pressed():
	get_tree().quit()


func _on_BtnPlay_pressed():
	SceneLoader.goto_scene("res://map/MainMap.tscn")


func _on_BtnSettings_pressed():
	SceneLoader.goto_scene("res://ui/Settings.tscn")
	pass # Replace with function body.
