extends Node2D
class_name BaseRoom

export var has_door_left : bool = false
export var has_door_right : bool = false
export var has_door_top : bool = false
export var has_door_bottom : bool = false
export var door_count : int = 0




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
	$DoorTop.visible = has_door_top
	$DoorLeft.visible = has_door_left
	$DoorRight.visible = has_door_right
	$DoorBottom.visible = has_door_bottom

func remove_door_at_key(key : int):
	if m_neighbours[key] != null:
		m_neighbours[key] = null
		door_count -= 1



func _on_GlitchDetectionArea_body_entered(body):
	if body.has_method("is_glitching"):
		if body.is_glitching():
			body.set_glitch_mode(false)
