extends Node2D


var m_room_dimensions : Vector2 = Vector2()
var m_room_grid : Array

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
	{ "scene": load("res://map/rooms/TestRoom2.tscn"), "weight": 2 },
	{ "scene": load("res://map/rooms/RandomRoom.tscn"), "weight": 5 }
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
	_init_room_grid(grid)
	emit_signal("level_loading_progress_changed",loading_states.GRID_LOADED)
	_create_rooms(grid)
	emit_signal("level_loading_progress_changed",loading_states.ROOMS_INITIALIZED)
	_add_doors()
	emit_signal("level_loading_progress_changed",loading_states.DOORS_SET)
	_spawn_player_and_mobs()
	emit_signal("level_loading_progress_changed",loading_states.DONE)
	
func _init_room_grid(grid :Array):
	m_room_grid = []
	for x in range(grid.size()):
		m_room_grid.append([])
		for y in range(grid[x].size()):
			m_room_grid[x].append(null)
	
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
							_place_room(x, y, m_starting_room)
						m_generator.Room_Type.NORMAL:
							_select_room_to_place(x, y, all_normal_weights, m_room_scenes)
						m_generator.Room_Type.SECRET:
							_select_room_to_place(x, y, all_secret_weights, m_secret_room_scenes)
		else:
			print("ERROR: Gewichtungen sind 0") # TODO
	else:
		print("ERROR: no rooms") #TODO
	
func _select_room_to_place(x: int, y: int, all_weights : int, room_list : Array) -> void:
	var weight = randi() % all_weights + 1	#Zufallszahl von 1 - Summe aller Gewichtungen
	for room in room_list:
		weight -= room.weight	#Ziehe die Gewichtung des Raums ab
		if weight <= 0 :		#Ist das Resultat <= 0 haben wir einen Gewinner
			_place_room(x, y, room.scene)
			break

func _place_room(x : int, y: int, sceneType : PackedScene) -> void:
	var posX = float(x)*m_room_dimensions.x
	var posY = float(y)*m_room_dimensions.y
	var room = sceneType.instance()
	room.position.x = posX
	room.position.y = posY
	m_room_grid[x][y] = room
	add_child(room)
	
func _get_neighbours(x : int, y : int) -> Dictionary:
	var neighbours = {
		Helper.direction.LEFT  : null,
		Helper.direction.RIGHT : null,
		Helper.direction.TOP   : null,
		Helper.direction.BOTTOM: null
	}
	if (x -1) >= 0:
		if m_room_grid[x-1][y] != null:
			neighbours[Helper.direction.LEFT] = m_room_grid[x-1][y]
	if (y -1) >= 0:
		if m_room_grid[x][y-1] != null:
			neighbours[Helper.direction.TOP] = m_room_grid[x][y-1]
	if (x + 1) < m_room_grid.size():
		if m_room_grid[x+1][y] != null:
			neighbours[Helper.direction.RIGHT] = m_room_grid[x+1][y]
	if (y + 1) < m_room_grid[0].size():
		if m_room_grid[x][y+1] != null:
			neighbours[Helper.direction.BOTTOM] = m_room_grid[x][y+1]
	return neighbours

func _add_doors() -> void:
	for x in range(m_room_grid.size()):
		for y in range(m_room_grid[x].size()):
			var room = m_room_grid[x][y]
			if room != null:
				room.set_doors(_get_neighbours(x,y))
	for x in range(m_room_grid.size()):
		for y in range(m_room_grid[x].size()):
			var room = m_room_grid[x][y]
			if room != null:
				room.remove_random_doors()
	for x in range(m_room_grid.size()):
		for y in range(m_room_grid[x].size()):
			var room = m_room_grid[x][y]
			if room != null:
				room.update_doors()
	

func _spawn_player_and_mobs() -> void:
	var player = m_player.instance()
	player.position = m_starting_room_pos + Vector2(10,10) #TODO 
	add_child(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
