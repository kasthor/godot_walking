extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAP_SIZE = Vector2(20, 20)
const CELL_SIZE = 256

const MAP_OFFSET = MAP_SIZE / 2 * -1
const MAP_START = Vector2.ZERO + MAP_OFFSET
const MAP_END = MAP_SIZE + MAP_OFFSET


var noise
var road_cap = [-0.2, 0.2]
var decor_rarity = 0.2
var decor_count = 21


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
	noise = OpenSimplexNoise.new()
	
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12

	make_background()
	make_road()
	make_decor()
	
	
	init_camera()
	center_player()
	
func init_camera():
	$"Player/Camera2D".limit_top = MAP_START.y * CELL_SIZE
	$"Player/Camera2D".limit_bottom = MAP_END.y * CELL_SIZE
	$"Player/Camera2D".limit_left = MAP_START.x * CELL_SIZE
	$"Player/Camera2D".limit_right = MAP_END.x * CELL_SIZE
	

func center_player():
	$"Player".position = Vector2.ZERO
	
func is_road_tile(x,y):
	var a = noise.get_noise_2d(x,y)
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
	
func make_decor():
	for x in range(MAP_START.x, MAP_END.x):
		for y in range(MAP_START.y, MAP_END.y):
			if not is_road_tile(x,y) and randf() < decor_rarity:
				$"Decor".set_cell(x, y, randi() % decor_count)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
