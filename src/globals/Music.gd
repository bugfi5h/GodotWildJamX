extends Node

var volume

func _ready():	
	var gameSettings = get_node("/root/GameSettings")
	GameSettings.connect("music_volume_changed", self, "_on_music_volume_changed")
	GameSettings.connect("music_volume_enable_changed", self, "_on_music_volume_enable_changed")
	
	_on_music_volume_changed(GameSettings.music_volume)
	_on_music_volume_enable_changed(GameSettings.music_enabled)
	
	_play_main_theme()

func _on_music_volume_changed(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(volume/100))

func _on_music_volume_enable_changed(enabled):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !enabled)


func _play_main_theme():
	$MainTheme.play()
