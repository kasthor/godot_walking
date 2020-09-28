extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const AVAILABLE_TREES = ["Tree1", "Tree2", "Tree3"]
const AVAILABLE_STUMPS = ["Stump1", "Stump2", "Stump3"]
onready var sprite = get_node("Sprite")


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.animation = get_random_tree()
	pass # Replace with function body.

func get_random_tree():
	return AVAILABLE_TREES[randi() % AVAILABLE_TREES.size()]
	
func get_random_stump():
	return AVAILABLE_STUMPS[randi() % AVAILABLE_STUMPS.size()]
	
func hurt():
	sprite.animation = get_random_stump()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
