extends Node2D


var m_room_dimensions : Vector2 = Vector2()

enum loading_states {
	START = 0,
	GRID_LOADED = 25,
	ROOMS_INITIALIZED = 50,
	DOORS_SET = 75,
	DONE = 100
}

var m_generator : Node2D = preload("res://test/Generator.gd").new()

var m_starting_room : PackedScene = preload("res://map/rooms/StartRoom.tscn")
var m_starting_room_pos : Vector2 = Vector2()
var m_player : PackedScene = preload("res://characters/PlayerCharacter.tscn")


var m_room_scenes : Array = [
	# hier neue Räume reinpacken: { scene: <path_to_scene>, weight: 5 }
	{ "scene": load("res://map/rooms/TestRoom1.tscn"), "weight": 4 },
	{ "scene": load("res://map/rooms/TestRoom2.tscn"), "weight": 2 }
]


var m_secret_room_scenes : Array = [
	{ "scene": load("res://map/rooms/TestRoom3.tscn"), "weight": 2 }
]


signal level_loading_progress_changed(loading_progress)
	

func initialize_level(display_size : Vector2) -> void:
	randomize()
	m_room_dimensions = display_size * $MapCamera.zoom
	emit_signal("level_loading_progress_changed",loading_states.START)
	var grid = m_generator.start_generation(10,10,20,5) # TODO VALUES
	emit_signal("level_loading_progress_changed",loading_states.GRID_LOADED)
	_create_rooms(grid)
	emit_signal("level_loading_progress_changed",loading_states.ROOMS_INITIALIZED)
	_set_doors()
	emit_signal("level_loading_progress_changed",loading_states.DOORS_SET)
	_spawn_player_and_mobs()
	emit_signal("level_loading_progress_changed",loading_states.DONE)
	
func _create_rooms(grid : Array) -> void:
	if (m_room_scenes.size() > 0 and m_secret_room_scenes.size() > 0):
		#Gesamt Gewichtung ausrechnen
		var all_normal_weights : int = 0
		var all_secret_weights : int = 0
		for room in m_room_scenes:
			all_normal_weights += room.weight
		for s_room in m_secret_room_scenes:
			all_secret_weights += s_room.weight
		if (all_normal_weights > 0 and all_secret_weights > 0) :
			#Iterieren über das Grid:
			for x in range(grid.size()):
				for y in range(grid[x].size()):
					match grid[x][y]:
						m_generator.Room_Type.START:
							m_starting_room_pos = Vector2(x*m_room_dimensions.x,y*m_room_dimensions.y)
							_place_room(m_starting_room_pos.x, m_starting_room_pos.y, m_starting_room)
						m_generator.Room_Type.NORMAL:
							_select_room_to_place(x*m_room_dimensions.x, y*m_room_dimensions.y, all_normal_weights, m_room_scenes)
						m_generator.Room_Type.SECRET:
							_select_room_to_place(x*m_room_dimensions.x, y*m_room_dimensions.y, all_secret_weights, m_secret_room_scenes)
		else:
			print("ERROR: Gewichtungen sind 0") # TODO
	else:
		print("ERROR: no rooms") #TODO
	
func _select_room_to_place(posX: int, posY: int, all_weights : int, room_list : Array) -> void:
	var weight = randi() % all_weights + 1	#Zufallszahl von 1 - Summe aller Gewichtungen
	for room in room_list:
		weight -= room.weight	#Ziehe die Gewichtung des Raums ab
		if weight <= 0 :		#Ist das Resultat <= 0 haben wir einen Gewinner
			_place_room(posX, posY, room.scene)
			break

func _place_room(posX : float, posY: float, sceneType : PackedScene) -> void:
	var room = sceneType.instance()
	room.position.x = posX
	room.position.y = posY
	add_child(room)
	

func _set_doors() -> void:
	pass

func _spawn_player_and_mobs() -> void:
	var player = m_player.instance()
	player.position = m_starting_room_pos + Vector2(10,10) #TODO 
	add_child(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
