extends BaseRoom

var decoIds : Array = []
var floorIds : Array = []

func _ready():
	randomize()
	decoIds.append($Deco.tile_set.find_tile_by_name("Floor4"))
	decoIds.append($Deco.tile_set.find_tile_by_name("Wall4"))
	
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor1"))
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor3"))
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor5"))
	floorIds.append($Ground.tile_set.find_tile_by_name("Floor6"))
	
	generate_deco(randi() % 12)
	generate_floor()

func generate_deco(amount : int) -> void:
	for i in range(amount):
		var x = (randi() % 24 + 3)
		var y = (randi() % 11 + 3)
		var decoId = decoIds[randi() % decoIds.size()]
		
		$Deco.set_cell(x, y, 34)

func generate_floor() -> void:
	var floorId = floorIds[randi() % floorIds.size()]
	
	for x in range(32):
		for y in range(20):
			if $Ground.get_cell(x, y) != TileMap.INVALID_CELL:
				$Ground.set_cell(x, y, floorId)