extends Node2D

const MAX_SECRET_ROOMS = 5
const MIN_SIZE_X = 7
const MIN_SIZE_Y = 7
const MAX_SIZE_X = 10
const MAX_SIZE_Y = 10
const MAX_ROOMS = 50

var m_grid : Array
var m_size_x : int = 7
var m_size_y : int = 7
var m_room_count : int = 12
var m_secret_room_count : int = 2
var m_placed_rooms : Array 
var m_generation_running : bool = false

enum Room_Type {
	NONE = 0,
	START = 1,
	NORMAL = 2,
	SECRET = 3	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	

func _init_grid() -> void:
	m_grid = []
	m_placed_rooms = []
	if m_size_x < MIN_SIZE_X:
		m_size_x = MIN_SIZE_X
	if m_size_x > MAX_SIZE_X:
		m_size_x = MAX_SIZE_X
	#$SizeXEdit.text = String(m_size_x)
	if m_size_y < MIN_SIZE_Y:
		m_size_y = MIN_SIZE_Y
	if m_size_y > MAX_SIZE_Y:
		m_size_y = MAX_SIZE_Y
	#$SizeYEdit.text = String(m_size_y)
	for x in range(m_size_x):
		m_grid.append([])
		for y in range(m_size_y):
			m_grid[x].append(Room_Type.NONE)
	if m_secret_room_count > MAX_SECRET_ROOMS:
		m_secret_room_count = MAX_SECRET_ROOMS	
		#$SecretRoomCountEdit.text = String(m_secret_room_count)
	if MAX_ROOMS < m_room_count:
		m_room_count = MAX_ROOMS
		#$RoomCountEdit.text = String(m_room_count)
		
func _print_grid() -> void:
	print("---------------------------------------")
	$RichTextLabel.text = ""
	for x in range(m_size_x):
		print(m_grid[x])	
		$RichTextLabel.text += "\n" + String(m_grid[x])
	print("---------------------------------------")	
		
		
func _generate_levels() -> void:
	_place_start()
	# Add attached rooms
	_place_normal_rooms()
	# Add not attached rooms
	_place_secret_rooms()

func _place_normal_rooms() -> void:
	for i in m_room_count:
		var possible_attachments = []
		var already_closed_rooms = []
		var retries = 0
		while possible_attachments.size() == 0:
			var rand_placed_room = m_placed_rooms[(randi() % m_placed_rooms.size())]
			if already_closed_rooms.find(rand_placed_room) == -1:
				var found_attachments = _get_possible_attachements_for_room(rand_placed_room)
				if found_attachments.size() > 2 || retries > 20:
					possible_attachments = found_attachments
				if found_attachments.size() == 0:
					already_closed_rooms.append(rand_placed_room)
				retries += 1
		var new_pos = possible_attachments[randi()%possible_attachments.size()]
		_add_room(new_pos, Room_Type.NORMAL)

func _place_secret_rooms() -> void:
	var secret_rooms_placed = 0
	var tries = 0
	while secret_rooms_placed < m_secret_room_count:
		var coord = Vector2(randi()%m_size_x, randi()%m_size_y)
		for room in m_placed_rooms:
			if (room.x == coord.x || room.y == coord.y) && !(room.x == coord.x && room.y == coord.y):
				if m_grid[coord.x][coord.y] == 0:
					if _get_neighbours_count(coord) == 0:
						_add_room(coord, Room_Type.SECRET)
						secret_rooms_placed += 1
						break;
		tries += 1
		if tries >= 100:
			break;


func _add_room(pos : Vector2, type : int):
	m_grid[pos.x][pos.y] = type
	m_placed_rooms.append(pos)
	
	
func _get_neighbours_count(room) -> int:
	var neighbours = 0
	var possible_combinations = [ 
		Vector2(room.x -1 , room.y),
		Vector2(room.x +1 , room.y),
		Vector2(room.x , room.y -1),
		Vector2(room.x , room.y + 1)]
	for comb in possible_combinations:
		if(comb.x >= 0 && comb.x < m_size_x && comb.y >= 0 && comb.y < m_size_y):
			if m_grid[comb.x][comb.y] != 0:
				neighbours += 1
	return neighbours
	
func _get_possible_attachements_for_room(room) -> Array:
	var possible_attachments = []
	var possible_combinations = [ 
		Vector2(room.x -1 , room.y),
		Vector2(room.x +1 , room.y),
		Vector2(room.x , room.y -1),
		Vector2(room.x , room.y + 1)]
	for comb in possible_combinations:
		if(comb.x > 0 && comb.x < m_size_x && comb.y > 0 && comb.y < m_size_y):
			if m_grid[comb.x][comb.y] == 0:
				possible_attachments.append(comb)
	return possible_attachments
	

	
func _place_start() -> void:
	var place = Vector2(randi()%m_size_x, randi()%m_size_y)
	_add_room(place, Room_Type.START)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_generation(size_x : int, size_y : int, room_count : int, secret_room_count : int) -> Array:
	var grid = null
	if !m_generation_running:
		m_generation_running = true
		m_size_x = size_x
		m_size_y = size_y
		m_room_count = room_count
		m_secret_room_count = secret_room_count
		_init_grid()
		_generate_levels()
		grid = m_grid
		m_generation_running = false
	return grid
	


func _on_Button_pressed() -> void:
	if !m_generation_running:
		m_generation_running = true
		m_size_x = int($SizeXEdit.text)
		m_size_y = int($SizeYEdit.text)
		m_room_count = int($RoomCountEdit.text)
		m_secret_room_count = int($SecretRoomCountEdit.text)
		_init_grid()
		_generate_levels()
		_print_grid()
		m_generation_running = false


