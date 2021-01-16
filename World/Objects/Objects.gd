extends KinematicBody2D


const TRANSFORMS = ["Grass01", "Grass02", "Grass03", "Grass04", "Grass05", "Grass06", "Grass07", "Grass08", "Graveyard01", "Rock01", 
	"Rock02", "Rock03", "Rock04", "Rock05", "Rock06", "Rock07", "Rock08", "Rock09", "Rock10", "Rock11", "Rock12", "Rune01", 
	"Rune02", "Rune03", "Rune04", "Rune05", "Rune06", "Rune07", "Skull01", "Skull02", "Skull03", "Spikes01", "Stump01", "Stump02", "Stump03"]

onready var sprite = get_node("AnimatedSprite")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.animation = get_random_object()
	pass # Replace with function body.


func get_random_object():
	return TRANSFORMS[randi() % TRANSFORMS.size()]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
