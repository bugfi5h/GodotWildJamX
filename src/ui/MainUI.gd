extends Control

func _ready() -> void:
	$NinePatchRect/Glorbmeter.max_value = GameState.get_player_max_glorb_meter()
	$NinePatchRect/Glorbmeter.value = GameState.get_player_glorb_meter()
	GameState.connect("player_glorb_meter_changed", self, "_on_glorb_meter_changed")
	GameState.connect("player_max_glorb_meter_changed", self, "_on_max_glorb_meter_changed")
	
func _on_glorb_meter_changed(value : int) -> void:
	$NinePatchRect/Glorbmeter.value = value
	
func _on_max_glorb_meter_changed(value : int) -> void:
	$NinePatchRect/Glorbmeter.max_value = value
