extends Node2D

enum direction {
	NONE = -1,
	LEFT = 0,
	RIGHT = 1,
	TOP = 2,
	BOTTOM = 3
}


func get_player() -> Node2D:
	return get_first_node_in_group("player")
	
func get_main_map() -> Node2D:
	return get_first_node_in_group("main_map")
	
func get_first_node_in_group(group_name : String) -> Node2D:
	var node = null
	var nodes = get_tree().get_nodes_in_group(group_name)
	if nodes.size() > 0:
		node = nodes[0]
	return node
	
func get_direction(from : Vector2, to : Vector2) -> Vector2:
	var direction = Vector2(to.x - from.x, to.y - from.y)
	return direction.normalized()
	
func limit(minimum : float, maximum : float, value : float) -> float:
	if(value < minimum):
		value = minimum
	elif(value > maximum):
		value = maximum
		
	return value