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
	
func get_direction(from : Vector2, to : Vector2) -> Vector2:
	var direction = Vector2(to.x - from.x, to.y - from.y)
	return direction.normalized()
	
func limit(minimum : float, maximum : float, value : float) -> float:
	if(value < minimum):
		value = minimum
	elif(value > maximum):
		value = maximum
		
	return value