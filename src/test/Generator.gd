extends Node2D


var grid : Array
export var size_x : int = 7
export var size_y : int = 7
export var room_count : int = 12
export var secret_room_count : int = 2

enum Room_Type {
	START = 1,
	NORMAL = 2,
	SECRET = 3	
}

var placed_rooms : Array 

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	

func _init_grid():
	grid = []
	placed_rooms = []
	for x in range(size_x):
		grid.append([])
		for y in range(size_y):
			grid[x].append(0)
	if (size_x * size_y) < room_count:
		room_count = size_x*size_y	
		
func _print_grid():
	print("---------------------------------------")
	$RichTextLabel.text = ""
	for x in range(size_x):
		print(grid[x])	
		$RichTextLabel.text += "\n" + String(grid[x])
	print("---------------------------------------")	
		
		
func _generate_levels():
	_place_start()
	# Add attached rooms
	for i in room_count:
		var possible_attachments = []
		var already_closed_rooms = []
		var retries = 0
		while possible_attachments.size() == 0:
			var rand_placed_room = placed_rooms[(randi() % placed_rooms.size())]
			if already_closed_rooms.find(rand_placed_room) == -1:
				var found_attachments = _get_possible_attachements_for_room(rand_placed_room)
				if found_attachments.size() > 2 || retries > 20:
					possible_attachments = found_attachments
				if found_attachments.size() == 0:
					already_closed_rooms.append(rand_placed_room)
				retries += 1
		var new_pos = possible_attachments[randi()%possible_attachments.size()]
		_add_room(new_pos, Room_Type.NORMAL)
	# Add not attached rooms
	var secret_rooms_placed = 0
	var tries = 0
	while secret_rooms_placed < secret_room_count:
		var coord = Vector2(randi()%size_x, randi()%size_y)
		for room in placed_rooms:
			if (room.x == coord.x || room.y == coord.y) && !(room.x == coord.x && room.y == coord.y):
				if grid[coord.x][coord.y] == 0:
					if _get_neighbours_count(coord) == 0:
						_add_room(coord, Room_Type.SECRET)
						secret_rooms_placed += 1
						break;
		tries += 1
		if tries >= 100:
			break;


func _add_room(pos : Vector2, type : int):
	grid[pos.x][pos.y] = type
	placed_rooms.append(pos)
	
	
func _get_neighbours_count(room) -> int:
	var neighbours = 0
	var possible_combinations = [ 
		Vector2(room.x -1 , room.y),
		Vector2(room.x +1 , room.y),
		Vector2(room.x , room.y -1),
		Vector2(room.x , room.y + 1)]
	for comb in possible_combinations:
		if(comb.x >= 0 && comb.x < size_x && comb.y >= 0 && comb.y < size_y):
			if grid[comb.x][comb.y] != 0:
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
		if(comb.x > 0 && comb.x < size_x && comb.y > 0 && comb.y < size_y):
			if grid[comb.x][comb.y] == 0:
				possible_attachments.append(comb)
	return possible_attachments
	

	
func _place_start():
	var place = Vector2(randi()%size_x, randi()%size_y)
	_add_room(place, Room_Type.START)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	size_x = int($SizeXEdit.text)
	size_y = int($SizeYEdit.text)
	room_count = int($RoomCountEdit.text)
	secret_room_count = int($SecretRoomCountEdit.text)
	_init_grid()
	_generate_levels()
	_print_grid()


