extends Camera2D

var m_grid_position :Vector2 = Vector2()

onready var parent : Node2D = get_parent()

func _ready():
	update_grid_position()
	

func _physics_process(delta):
	update_grid_position()

func get_player() -> Node2D:
	var player = null
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	return player

func update_grid_position():
	var player = get_player()
	if player != null && parent.m_room_dimensions != Vector2():
		print(player.position)
		var x = int(player.position.x / parent.m_room_dimensions.x)
		var y = int(player.position.y / parent.m_room_dimensions.y)
		var new_grid_position = Vector2(x,y)
		if m_grid_position != new_grid_position:
			m_grid_position = new_grid_position
			position = m_grid_position * parent.m_room_dimensions
		