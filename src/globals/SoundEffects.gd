extends Node

var volume

func _ready():
	var sceneLoader = get_node("/root/SceneLoader")
	sceneLoader.connect("scene_changed", self, "_on_scene_changed")
	connect_nodes(sceneLoader.m_current_scene)
	
	var gameSettings = get_node("/root/GameSettings")
	GameSettings.connect("sound_volume_changed", self, "_on_sound_volume_changed")
	GameSettings.connect("sound_volume_enable_changed", self, "_on_sound_volume_enable_changed")

func _on_sound_volume_changed(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(volume/100))

func _on_sound_volume_enable_changed(enabled):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !enabled)

func _on_scene_changed(new_scene):
	connect_nodes(new_scene)

func connect_nodes(scene: Node):
	var children = scene.get_children()
	for child in children:
		connect_nodes(child)
		if child is Button || child is TextureButton:
			child.connect("pressed", self, "_play_button_click")

func _play_button_click():
	
	$ButtonClick.play()
