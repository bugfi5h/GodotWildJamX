extends Camera2D

var m_grid_position :Vector2 = Vector2()

export var debug : bool = false
var debug_update_once : bool = false

onready var m_parent : Node2D = get_parent()

func _ready() -> void:
	_update_grid_position()

func _physics_process(delta) -> void:	
	if !debug:
		_update_grid_position()
	else:
		if !debug_update_once:
			_update_grid_position()
			debug_update_once = true
		else:
			_handle_debug_movement(delta)
		
func _handle_debug_movement(delta : int) -> void:
	var velocity = Vector2()
	var zoom_velocity = Vector2()
	if Input.is_key_pressed(KEY_Z):
		zoom = zoom + Vector2(0.1,0.1)
	if Input.is_key_pressed(KEY_U):
		zoom = zoom - Vector2(0.1,0.1)
	if Input.is_key_pressed(KEY_KP_8):
		position.y -= 10
	if Input.is_key_pressed(KEY_KP_4):
		position.x -= 10
	if Input.is_key_pressed(KEY_KP_2):
		position.y += 10
	if Input.is_key_pressed(KEY_KP_6):
		position.x += 10
	#zoom = zoom + zoom_velocity.normalized()*delta

func _update_grid_position() -> void:
	var player = Helper.get_player()
	if player != null && m_parent.m_room_dimensions != Vector2():
		var x = int(player.position.x / m_parent.m_room_dimensions.x)
		var y = int(player.position.y / m_parent.m_room_dimensions.y)
		var new_grid_position = Vector2(x,y)
		if m_grid_position != new_grid_position:
			m_grid_position = new_grid_position
			position = m_grid_position * m_parent.m_room_dimensions
		