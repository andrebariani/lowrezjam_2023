extends Node2D

@onready var terrain_map = $TerrainMap
@onready var mountain_map = $MountainMap
const MAP_SIZE = Vector2(66, 66)
const MOUNTAIN_MAP_SIZE = Vector2(16, 16)
const HEIGHT_CAP = 0
const MOUNTAIN_CAP = -0.45
const ISLAND_CAP = -0.6
const TEMP_CAP = 0.3
const WETNESS_CAP = -0.35

var noise_continent = FastNoiseLite.new()
var noise_island = FastNoiseLite.new()
var world_seed = -506746695 # randi()
var island_seed = 0 # randi()

var noise_temp = FastNoiseLite.new()
var temp_seed = 0
var noise_wetness = FastNoiseLite.new()
var wetness_seed = 0

var seeds_that_i_liked = [
	-1322133361,
	-503983279,
	-506746695,
	-1692458005, 
	1615923038, # dino land at (-72, -112, 0)!
	-385648067, # cool spiral
	-963670768, # duo biome island
	1198518664, # funny critter
]

var layers = {
	"height": {
		map_size = Vector2(512, 512),
		noise = FastNoiseLite.new(),
		octaves = 5.0,
		seed = 64,
		cap = 0,
		invert_cap = false,
		use_same_height_noise = true,
	},
	"mt": {
		map_size = Vector2(32, 32),
		noise = FastNoiseLite.new(),
		octaves = 3,
		period = 8,
		cap = 0.35,
		invert_cap = false,
		use_same_height_noise = true
	},
}


func _ready():
	noise_continent.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise_continent.seed = world_seed
	noise_temp.seed = temp_seed
	noise_wetness.seed = wetness_seed
	generate_world()

var cells_land = []
var cells_water = []
var continent_offset = Vector3.ZERO
var mountain_offset = Vector3.ZERO
func generate_world():
	terrain_map.clear()
	
	noise_continent.offset = continent_offset
	noise_temp.offset = continent_offset
	noise_wetness.offset = continent_offset
	
	# Generate land
	
	noise_continent.fractal_octaves = 4
	noise_continent.frequency = 0.02
	
	noise_temp.fractal_octaves = 2
	noise_temp.frequency = 0.01
	noise_wetness.fractal_octaves = 2
	noise_wetness.frequency = 0.05
	for x in MAP_SIZE.x:
		for y in MAP_SIZE.y:
			var pos = Vector2i(x - 1, y - 1)
			# generate height
			var height = noise_continent.get_noise_2dv(pos)
			
			if height <= HEIGHT_CAP:
				# generate temp
				var temp = noise_temp.get_noise_2dv(pos)
				
				if temp <= -TEMP_CAP:
					terrain_map.set_cell(0, pos, 1, Vector2(2, 0))
				elif temp >= TEMP_CAP:
					terrain_map.set_cell(0, pos, 1, Vector2(4, 0))
				else:
					terrain_map.set_cell(0, pos, 0, Vector2(0, 1))
					
				# generate wetness
				var wet = noise_wetness.get_noise_2dv(pos)
				
				if wet <= -TEMP_CAP:
					terrain_map.set_cell(0, pos, 1, Vector2(1, 0))
			else:
				terrain_map.set_cell(0, pos, 0, Vector2(6, 1))
	
	noise_continent.offset = mountain_offset
	# Generate mountains
	mountain_map.clear()
	noise_continent.fractal_octaves = 4.0
	noise_continent.frequency = 0.08
	for x in MOUNTAIN_MAP_SIZE.x:
		for y in MOUNTAIN_MAP_SIZE.y:
			var pos = Vector2i(x, y)
			# generate height
			var height = noise_continent.get_noise_2dv(pos)
			
			if height <= MOUNTAIN_CAP:
				mountain_map.set_cell(0, pos, 0, Vector2(3, 11))
	
	# terrain_map.set_cells_terrain_connect(0, cells_land, 0, 0)
	# terrain_map.set_cells_terrain_connect(0, cells_water, 0, 1)
	
	#for x in MAP_SIZE.x:
	#	for y in MAP_SIZE.y:
	#		var pos = Vector2(x, y)
	#		generate_height(Vector2(x, y))


func _process(_delta):
	if Input.is_action_just_pressed("randomize"):
		noise_continent.seed = randi()
		noise_temp.seed = randi()
		noise_wetness.seed = randi()
		print_debug("Generating with seed: %s" % [noise_continent.seed])
		generate_world()
		
	if Input.is_action_just_pressed("select"):
		var clicked_pos = terrain_map.local_to_map(get_global_mouse_position())
		print_debug("height on %s: %s" % [clicked_pos, noise_continent.get_noise_2dv(clicked_pos)])
		
	var offset_dir = Vector2.ZERO
	offset_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	offset_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if offset_dir != Vector2.ZERO:
		continent_offset += Vector3(offset_dir.x, offset_dir.y,  0) * 8
		mountain_offset += Vector3(offset_dir.x, offset_dir.y,  0) * 2
		generate_world()


#func _generate_height(pos: Vector2, noise: FastNoiseLite, cap, invert: false):
#	var height = noise_continent.get_noise_2dv(pos)
	
#	if height <= HEIGHT_CAP:
#		cells_land.append(pos)
#	else:
#		cells_water.append(pos)
