extends Node2D

@onready var terrain_map = $TerrainMap
const MAP_SIZE = Vector2(512, 512)
const CONTINENT_CAP = 0

var noise_continent = FastNoiseLite.new()
var noise_island = FastNoiseLite.new()
var world_seed = 0 # randi()
var island_seed = 0 # randi()


var layers = {
	"grass": {
		map_size = Vector2(400, 224),
		noise = FastNoiseLite.new(),
		octaves = 5.0,
		period = 64,
		cap = 0,
		cap_op = true,
		use_same_noise = true,
	},
	"mt": {
		map_size = Vector2(50, 28),
		noise = FastNoiseLite.new(),
		octaves = 3,
		period = 8,
		cap = 0.35,
		cap_op = true,
		use_same_noise = true
	},
	"island": {
		map_size = Vector2(400, 224),
		noise = FastNoiseLite.new(),
		octaves = 0,
		period = 12,
		cap = 0.7,
		cap_op = true,
		use_same_noise = true
	},
	"tree": {
		map_size = Vector2(400, 224),
		noise = FastNoiseLite.new(),
		octaves = 2,
		period = 24,
		cap = 0.4,
		cap_op = true,
		use_same_noise = true
	},
}


func _ready():
	noise_continent.seed = world_seed
	generate_world()
	
func generate_world():
	generate_continent()
	

func generate_continent():
	var cells_land = []
	var cells_water = []
	for x in MAP_SIZE.x:
		for y in MAP_SIZE.y:
			var height = noise_continent.get_noise_2d(x, y)
			if height < CONTINENT_CAP:
				cells_land.append(Vector2(x, y))
			else:
				cells_water.append(Vector2(x, y))
				
	terrain_map.set_cells_terrain_connect(0, cells_land, 0, 0)
	terrain_map.set_cells_terrain_connect(0, cells_water, 0, 1)
