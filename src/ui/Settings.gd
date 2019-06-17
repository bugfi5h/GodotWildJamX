extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready()-> void:
	$MarginContainer/VBoxContainer/Musik/NinePatchRect/Volume/MusikSlider.value = GameSettings.music_volume
	$MarginContainer/VBoxContainer/Sound/NinePatchRect/Volume/SoundSlider.value = GameSettings.sound_volume
	$MarginContainer/VBoxContainer/Musik/BtnMusic.pressed = !GameSettings.music_enabled
	$MarginContainer/VBoxContainer/Sound/BtnSound.pressed = !GameSettings.sound_enabled 

func _on_BtnBack_pressed() -> void:
	SceneLoader.goto_menu_scene("res://ui/MainMenue.tscn")
	pass # Replace with function body.

func _on_SoundSlider_value_changed(value) -> void:
	$MarginContainer/VBoxContainer/Sound/NinePatchRect/Volume.value = value
	GameSettings.set_sound_volume(value)
	
func _on_MusikSlider_value_changed(value)-> void:
	$MarginContainer/VBoxContainer/Musik/NinePatchRect/Volume.value = value
	GameSettings.set_music_volume(value)

func _on_BtnMusic_toggled(button_pressed)-> void:
	GameSettings.set_music_enabled(!button_pressed)

func _on_BtnSound_toggled(button_pressed)-> void:
	GameSettings.set_sound_enabled(!button_pressed)
