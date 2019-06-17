extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Musik/NinePatchRect/Volume/MusikSlider.value = GameSettins.music_volume
	$MarginContainer/VBoxContainer/Sound/NinePatchRect/Volume/SoundSlider.value = GameSettins.sound_volume
	$MarginContainer/VBoxContainer/Musik/BtnMusic.pressed = !GameSettins.music_enabled
	$MarginContainer/VBoxContainer/Sound/BtnSound.pressed = !GameSettins.sound_enabled 

func _on_BtnBack_pressed():
	SceneLoader.goto_menu_scene("res://ui/MainMenue.tscn")
	pass # Replace with function body.

func _on_SoundSlider_value_changed(value):
	$MarginContainer/VBoxContainer/Sound/NinePatchRect/Volume.value = value
	GameSettins.set_sound_volume(value)
	
func _on_MusikSlider_value_changed(value):
	$MarginContainer/VBoxContainer/Musik/NinePatchRect/Volume.value = value
	GameSettins.set_music_volume(value)

func _on_BtnMusic_toggled(button_pressed):
	GameSettins.set_music_enabled(!button_pressed)

func _on_BtnSound_toggled(button_pressed):
	GameSettins.set_sound_enabled(!button_pressed)
