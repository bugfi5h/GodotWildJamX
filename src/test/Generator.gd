extends Node2D


var grid : Array
export var size_x : int = 7
export var size_y : int = 7
export var room_count : int = 12

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
		_add_room(new_pos)


func _add_room(pos : Vector2):
	grid[pos.x][pos.y] = 1
	placed_rooms.append(pos)
	_print_grid()
	#_wait(1)
	
func _wait(time_in_seconds: int):
	var t = $Timer
	t.wait_time = time_in_seconds
	t.one_shot = true
	t.start()
	yield(t, "timeout")
	
	
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
	_add_room(place)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	size_x = int($SizeXEdit.text)
	size_y = int($SizeYEdit.text)
	room_count = int($RoomCountEdit.text)
	_init_grid()
	_generate_levels()


