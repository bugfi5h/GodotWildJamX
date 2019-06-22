extends Control

export var sprite : Texture = null

var m_player
var m_room_grid : Array = []
var m_main_map
var m_minimap_grid : Array = []
var m_current_room : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	m_main_map = Helper.get_main_map()
	m_room_grid = m_main_map.m_room_grid
	
	init_grid()

func init_grid() -> void:
	if sprite == null:
		printerr("Minimap needs initialized sprites.")
	
	$GridContainer.set_columns(m_room_grid[0].size())
	
	for x in range(m_room_grid.size()):
		m_minimap_grid.append([])
		for y in range(m_room_grid[x].size()):
			var transparency = 0.0
			if(m_room_grid[x][y] == null):
				transparency = 0.0
			else :
				m_room_grid[x][y].connect("player_entered_room", self, "_on_player_entered_room")
				
			var texture = create_texture(transparency)
			m_minimap_grid[x].append({ 
				"room": m_room_grid[x][y],
				"texture": texture,
				"active": false
			})
	
	for y in range(m_room_grid[0].size()):
		for x in range(m_room_grid.size()):
			$GridContainer.add_child(m_minimap_grid[x][y]["texture"])

func create_texture(transparency : float) -> TextureRect:
	var room_texture : TextureRect = TextureRect.new()
	room_texture.set_texture(sprite)
	room_texture.modulate = Color(1,1,1,transparency)
	return room_texture
	
func _on_player_entered_room(room):
	set_current_room()

func set_current_room() -> void:
	if m_current_room != {}:
		m_current_room["active"] = false
		
	var new_room_position = m_main_map.to_grid_position(get_player().position)
	
	var new_room : Dictionary = m_minimap_grid[new_room_position.x][new_room_position.y]
	new_room["active"] = true
	new_room["texture"].modulate = Color(1,1,1,1)
	m_current_room = new_room
		
func get_player():
	if m_player == null:
		m_player = Helper.get_player()
	return m_player