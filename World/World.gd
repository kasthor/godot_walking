extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Tree = preload("res://World/Tree/Tree.tscn")

const MAP_SIZE = Vector2(20, 20)
const CELL_SIZE = 256
const TREE_DENSITY = 6

const MAP_OFFSET = MAP_SIZE / 2 * -1
const MAP_START = Vector2.ZERO + MAP_OFFSET
const MAP_END = MAP_SIZE + MAP_OFFSET


var road_noise
var tree_noise
var road_cap = [-0.2, 0.2]
var decor_rarity = 0.2
var decor_count = 21


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
	init_road_noise()
	init_tree_noise()

	make_background()
	make_road()
	make_trees()
	
	init_camera()
	center_player()
	
func camera():
	return get_node("Objects/Player/Camera2D")
	
func player():
	return get_node("Objects/Player")
	
	
func init_road_noise():
	road_noise = OpenSimplexNoise.new()
	
	road_noise.seed = randi()
	road_noise.octaves = 1.0
	road_noise.period = 12
	
func init_tree_noise():
	tree_noise = OpenSimplexNoise.new()
	
	tree_noise.seed = randi()
	tree_noise.octaves = 1.0
	tree_noise.period = 12
	
func init_camera():
	camera().limit_top = MAP_START.y * CELL_SIZE
	camera().limit_bottom = MAP_END.y * CELL_SIZE
	camera().limit_left = MAP_START.x * CELL_SIZE
	camera().limit_right = MAP_END.x * CELL_SIZE
	

func center_player():
	player().position = Vector2.ZERO
	
func is_road_tile(x,y):
	var a = road_noise.get_noise_2d(x,y)
	return a > road_cap[0] and a < road_cap[1]
		
func make_background():
	for x in range(MAP_START.x, MAP_END.y):
		for y in range(MAP_START.y, MAP_END.y):
			$"Background".set_cell(x,y, 0)	

func make_road():
	for x in range(MAP_START.x, MAP_END.x):
		for y in range(MAP_START.y, MAP_END.y):
			if is_road_tile(x, y):
				$"Road".set_cell(x, y, 0)
	
	$"Road".update_bitmask_region(MAP_START, MAP_END)
	
func make_trees():
	for x in range(MAP_START.x, MAP_END.x):
		for y in range(MAP_START.y, MAP_END.y):
			if not is_road_tile(x,y):
				make_trees_in_cell(x,y)
	
func make_trees_in_cell(x,y):
	for i in range(int(abs(tree_noise.get_noise_2d(x, y)) * TREE_DENSITY)):
		var pos_x = x * CELL_SIZE + randi() % CELL_SIZE
		var pos_y = y * CELL_SIZE + randi() % CELL_SIZE
		var tree = Tree.instance()
		tree.position = Vector2(pos_x, pos_y)
		$Objects.add_child(tree)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
