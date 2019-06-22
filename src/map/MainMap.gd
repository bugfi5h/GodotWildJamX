extends Node2D

var m_room_dimensions : Vector2 = Vector2()
var m_room_grid : Array

export var x_room_count : int = 10
export var y_room_count : int = 10
export var rooms : int = 20
export var secret_rooms :int = 3

var m_mega_glorbs : int = 0
var m_glorbs_to_find : int = 4

signal found_all_glorbs()
signal glorb_count_changed(value)
signal glorbs_to_find_changed(value)

func get_stage_dimensions() -> Vector2:
	return m_room_dimensions * Vector2(x_room_count, y_room_count)

func _init():
	add_to_group("main_map");

func _ready():
	m_glorbs_to_find = GameState.glorbs_to_find
	emit_signal("glorb_count_changed", m_mega_glorbs)
	emit_signal("glorbs_to_find_changed", m_glorbs_to_find)
	GameState.highscore += 1

func add_mega_glorb() -> void:
	m_mega_glorbs += 1
	emit_signal("glorb_count_changed", m_mega_glorbs)
	if m_mega_glorbs >= m_glorbs_to_find:
		#play animation!
		emit_signal("found_all_glorbs")
		#erstmal. Klären wär das Level wechselt
		SceneLoader.goto_scene("res://map/MainMap.tscn")

enum loading_states {
	START = 0,
	GRID_LOADED = 25,
	ROOMS_INITIALIZED = 50,
	DOORS_SET = 75,
	DONE = 100
}

var m_generator : Node2D = preload("res://test/Generator.gd").new()

var m_starting_room_packed : PackedScene = preload("res://map/rooms/StartRoom.tscn")
var m_starting_room : Node2D = null
var m_player : PackedScene = preload("res://characters/player/PlayerCharacter.tscn")
var m_mega_glorb : PackedScene = preload("res://items/glorbs/MegaGlorb.tscn")
var m_empty_space : PackedScene = preload("res://map/rooms/EmptySpace.tscn")

var m_room_scenes : Array = [
	# hier neue Räume reinpacken: { scene: <path_to_scene>, weight: 5 }
	{ "scene": load("res://map/rooms/TestRoom1.tscn"), "weight": 4 },
	{ "scene": load("res://map/rooms/TestRoom2.tscn"), "weight": 2 },
	{ "scene": load("res://map/rooms/RandomRoom.tscn"), "weight": 5 }
]


var m_secret_room_scenes : Array = [
	{ "scene": load("res://map/rooms/templates/SecretRoom.tscn"), "weight": 2 }
]


signal level_loading_progress_changed(loading_progress)
	

func initialize_level(display_size : Vector2) -> void:
	randomize()
	m_room_dimensions = display_size * $MapCamera.zoom
	emit_signal("level_loading_progress_changed",loading_states.START)
	var grid = m_generator.start_generation(x_room_count,y_room_count,rooms,secret_rooms) # TODO VALUES
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
							_place_room(x, y, m_starting_room_packed)
							m_starting_room = m_room_grid[x][y]
						m_generator.Room_Type.NORMAL:
							_select_room_to_place(x, y, all_normal_weights, m_room_scenes)
						m_generator.Room_Type.SECRET:
							_select_room_to_place(x, y, all_secret_weights, m_secret_room_scenes)
						m_generator.Room_Type.NONE:
							_place_empty_space(x,y)
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

func _place_empty_space(x : int, y: int) -> void:
	var posX = float(x)*m_room_dimensions.x
	var posY = float(y)*m_room_dimensions.y
	var e_space = m_empty_space.instance()
	e_space.position.x = posX
	e_space.position.y = posY
	add_child(e_space)

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
	player.position = m_starting_room.position + (m_room_dimensions / 2)
	add_child(player)
	for i in range(GameState.glorbs_to_find):
		var x = randi()%x_room_count
		var y = randi()%y_room_count
		while (m_room_grid[x][y] == null or m_room_grid[x][y] == m_starting_room or m_room_grid[x][y].has_node("MegaGlorb")):
			x = randi()%x_room_count
			y = randi()%y_room_count
		var glorb = m_mega_glorb.instance()
		var room = m_room_grid[x][y]
		glorb.position = m_room_dimensions / 2 
		glorb.set_main_map(self)
		room.add_child(glorb)
		print(i)
	
func disable_camera_smoothing_for_frame() -> void:
	$MapCamera.disable_smoothing_for_frame()

func to_grid_position(pos : Vector2) -> Vector2:
	var x = int(pos.x / m_room_dimensions.x)
	var y = int(pos.y / m_room_dimensions.y)
	return Vector2(x,y)
