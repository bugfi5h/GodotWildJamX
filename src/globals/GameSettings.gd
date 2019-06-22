extends Node

export var music_volume : float = 80
export var sound_volume : float = 80

export var music_enabled : bool = true
export var sound_enabled : bool = true

signal music_volume_changed(value)
signal sound_volume_changed(value)
signal music_volume_enable_changed(enabled)
signal sound_volume_enable_changed(enabled)

var init : bool = false
func initSounds():
	if !init:
		set_music_volume(40)
		set_sound_volume(40)
		set_sound_enabled(true)
		set_music_enabled(true)
		init = true

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