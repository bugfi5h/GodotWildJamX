extends BaseRoom

var decoIds : Array = []
var floorIds : Array = []
var enemies : Array = []

func _ready():
	randomize()
	decoIds.append($Deco.tile_set.find_tile_by_name("Floor4"))
	
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor1"))
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor3"))
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor5"))
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor6"))
	
	enemies.append(load("res://characters/robot/Robot.tscn"))
	enemies.append(load("res://characters/Asteroid.tscn"))
	enemies.append(load("res://characters/tinyRobot/TinyRobot.tscn"))
	
	generate_deco(randi() % 12)
	generate_floor()
	add_monsters(randi() % 3)

func generate_deco(amount : int) -> void:
	for i in range(amount):
		var decoId = decoIds[randi() % decoIds.size()]
		$Deco.set_cellv(get_random_tilemap_position(), decoId)

func generate_floor() -> void:
	var floorId = floorIds[randi() % floorIds.size()]
	
	for x in range(32):
		for y in range(20):
			if $Ground.get_cell(x, y) != TileMap.INVALID_CELL:
				$Ground.set_cell(x, y, floorId)

func add_monsters(amount : int) -> void:
	for i in range(amount):
		var enemyType = enemies[randi() % enemies.size()]
		var enemy = enemyType.instance()
		enemy.position = get_random_position()
		add_child(enemy)

func get_random_tilemap_position() -> Vector2:
	return Vector2(randi() % 24 + 3, randi() % 11 + 3)

func get_random_position() -> Vector2:
	return $Deco.map_to_world(get_random_tilemap_position())