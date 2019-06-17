extends Node2D

enum direction {
	NONE = -1,
	LEFT = 0,
	RIGHT = 1,
	TOP = 2,
	BOTTOM = 3
}


func get_player() -> Node2D:
	var player = null
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	return player