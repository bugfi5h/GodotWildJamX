extends Camera2D

var m_grid_position :Vector2 = Vector2()

onready var m_parent : Node2D = get_parent()

func _ready() -> void:
	update_grid_position()
	

func _physics_process(delta) -> void:
	update_grid_position()

func update_grid_position() -> void:
	var player = Helper.get_player()
	if player != null && m_parent.m_room_dimensions != Vector2():
		var x = int(player.position.x / m_parent.m_room_dimensions.x)
		var y = int(player.position.y / m_parent.m_room_dimensions.y)
		var new_grid_position = Vector2(x,y)
		if m_grid_position != new_grid_position:
			m_grid_position = new_grid_position
			position = m_grid_position * m_parent.m_room_dimensions
		