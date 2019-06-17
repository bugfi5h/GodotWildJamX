extends Node

export var music_volume : float = 50
export var sound_volume : float = 50

export var music_enabled : bool = false
export var sound_enabled : bool = true

signal music_volume_changed(value)
signal sound_volume_changed(value)
signal music_volume_enable_changed(enabled)
signal sound_volume_enable_changed(enabled)

func set_music_volume(value: float)-> void:
	if value != music_volume:
		music_volume = value
		emit_signal("music_volume_changed",value)

func set_sound_volume(value: float)-> void:
	if value != sound_volume:
		sound_volume = value
		emit_signal("sound_volume_changed",value)
		
func set_music_enabled(enabled: bool)-> void:
	if enabled != music_enabled:
		music_enabled = enabled
		emit_signal("music_volume_enable_changed",enabled)
		
func set_sound_enabled(enabled: bool)-> void:
	if enabled != sound_enabled:
		sound_enabled = enabled
		emit_signal("sound_volume_enable_changed",enabled)