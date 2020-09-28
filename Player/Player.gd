extends KinematicBody2D

var speed = 100

func _ready():
	pass # Replace with function body.

func animation():
	return get_node("AnimatedSprite")

func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"): velocity.y -= 1
	if Input.is_action_pressed("ui_down"): velocity.y += 1
	if Input.is_action_pressed("ui_left"): velocity.x -= 1
	if Input.is_action_pressed("ui_right"): velocity.x += 1
	
	move_and_slide(velocity.normalized() * speed) 
	player_animation(velocity)

func player_animation(velocity):
	var rotation = 0
	
	if velocity.x > 0:
		animation().flip_h = false
	elif velocity.x < 0:
		animation().flip_h = true
	
	rotation = velocity.y * 20
	rotation *= -1 if animation().flip_h else 1
	animation().rotation_degrees = rotation
	
	
	if velocity.x != 0 or velocity.y != 0:
		animation().play("walk") 
	else: 
		animation().play("idle")
