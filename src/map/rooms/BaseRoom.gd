extends Node2D
class_name BaseRoom

signal player_entered_room

export var has_door_left : bool = false
export var has_door_right : bool = false
export var has_door_top : bool = false
export var has_door_bottom : bool = false
export var door_count : int = 0

var m_floor_door_tiles : Dictionary = {
	Helper.direction.LEFT: 	[Vector2(0,7), Vector2(0,8)],
	Helper.direction.RIGHT:	[Vector2(29,7), Vector2(29,8)],
	Helper.direction.TOP:	[Vector2(14,0), Vector2(15,0)],
	Helper.direction.BOTTOM:[Vector2(14,15), Vector2(15,15)],
}

var m_wall_no_door_tiles : Dictionary = {
	Helper.direction.LEFT: 	[Vector2(0,7), Vector2(0,8), Vector2(1,7), Vector2(1,8)],
	Helper.direction.RIGHT:	[Vector2(28,7), Vector2(28,8), Vector2(29,7), Vector2(29,8)],
	Helper.direction.TOP:	[Vector2(14,0), Vector2(15,0), Vector2(14,1), Vector2(15,1)],
	Helper.direction.BOTTOM:[Vector2(14,14), Vector2(15,14), Vector2(14,15), Vector2(15,15)],
}

var m_wall_door_tiles : Dictionary = {
	Helper.direction.LEFT: 	[Vector2(0,6), Vector2(0,9)],
	Helper.direction.RIGHT:	[Vector2(29,6), Vector2(29,9)],
	Helper.direction.TOP:	[Vector2(13,0), Vector2(16,0)],
	Helper.direction.BOTTOM:[Vector2(13,15), Vector2(16,15)],
}

var m_neighbours : Dictionary

onready var m_parent = get_parent()

func _ready():
	pass
	
func set_doors(neighbours : Dictionary) -> void:
	m_neighbours = neighbours
	door_count = 0
	if m_neighbours[Helper.direction.LEFT] != null:
			has_door_left = true
			door_count +=1
	if m_neighbours[Helper.direction.RIGHT] != null:
			has_door_right = true
			door_count +=1
	if m_neighbours[Helper.direction.TOP] != null:
			has_door_top = true
			door_count +=1
	if m_neighbours[Helper.direction.BOTTOM] != null:
			has_door_bottom = true
			door_count +=1

func remove_random_doors() -> void:
	if door_count < 3 : # Keine Tür entfernen um sicherzustellen, dass jeder Raum erreichbar bleibt
		return
	randomize()
	var remove_doors = min(0,door_count - randi()%3)
	var valid_neighbour_keys = []
	for key in m_neighbours.keys():
		if m_neighbours[key] != null && m_neighbours[key].door_count > 2:
			valid_neighbour_keys.append(key)
	for i in range(remove_doors):
		if valid_neighbour_keys.size() > 0: #lösche Türen solange der Vorat reicht
			var index = randi() % valid_neighbour_keys.size()
			var opposite_key = _get_opposite_key(valid_neighbour_keys[index])
			m_neighbours[valid_neighbour_keys[index]].remove_door_at_key(opposite_key)
			remove_door_at_key(valid_neighbour_keys[index])
			
func _get_opposite_key(key : int) -> int:
	var opposite_key = Helper.direction.NONE
	match key:
		Helper.direction.LEFT:
			opposite_key = Helper.direction.RIGHT
		Helper.direction.RIGHT:
			opposite_key = Helper.direction.LEFT
		Helper.direction.TOP:
			opposite_key = Helper.direction.BOTTOM
		Helper.direction.BOTTOM:
			opposite_key = Helper.direction.TOP
	return opposite_key
			
func update_doors() -> void:
	set_door_tiles(Helper.direction.LEFT, has_door_left)
	set_door_tiles(Helper.direction.TOP, has_door_top)
	set_door_tiles(Helper.direction.BOTTOM, has_door_bottom)
	set_door_tiles(Helper.direction.RIGHT, has_door_right)
	
func set_door_tiles(direction : int, has_door : bool) -> void:
	if has_door:
		var tiles_to_remove = m_wall_no_door_tiles[direction]
		for pos in tiles_to_remove:
			$Walls.set_cell(pos.x, pos.y, -1)
	else:
		var wall_tiles_to_remove = m_wall_door_tiles[direction]
		for pos in wall_tiles_to_remove:
			$Walls.set_cell(pos.x, pos.y, -1)
		var floor_tiles_to_remove = m_floor_door_tiles[direction]
		for pos in floor_tiles_to_remove:
			$Ground.set_cell(pos.x, pos.y, -1)

func remove_door_at_key(key : int):
	if m_neighbours[key] != null:
		m_neighbours[key] = null
		door_count -= 1

func _on_GlitchDetectionArea_body_entered(body):
	if body.has_method("is_glitching"):
		if body.is_glitching():
			body.set_glitch_mode(false)
	if body.is_in_group("player"):
		emit_signal("player_entered_room", self)
			
func _on_enemy_shooting(bullet : PackedScene, _position : Vector2, _direction : Vector2, _damage : int):
	var b = bullet.instance()
	b.damage = _damage
	add_child(b)
	b.start(_position, _direction)
