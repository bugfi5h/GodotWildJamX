extends Node2D

func get_player() -> Node2D:
	var player = null
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	return player