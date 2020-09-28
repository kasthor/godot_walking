extends KinematicBody2D

var speed = 300
var attack

onready var animation = get_node("AnimatedSprite")
onready var attackPivot = get_node("AttackPivot")
onready var hitBox = get_node("AttackPivot/Hitbox")
onready var anger = get_node("Anger")
onready var steps = get_node("Steps")

func _ready():
	animation.connect("animation_finished", self, "idle")
	# idle()

func _process(delta):
	var velocity = Vector2.ZERO
	
	if not attack:
		if Input.is_action_pressed("ui_up"): velocity.y -= 1
		if Input.is_action_pressed("ui_down"): velocity.y += 1
		if Input.is_action_pressed("ui_left"): velocity.x -= 1
		if Input.is_action_pressed("ui_right"): velocity.x += 1
		if Input.is_action_pressed("ui_select"):
			attack = true;
			hitBox.disabled = false
			animation.play("attack")
			if not anger.playing:
				anger.play() 
			
			
	
	move_and_slide(velocity.normalized() * speed) 
	player_animation(velocity)

func player_animation(velocity):
	var rotation = 0
	
	if velocity.x > 0:
		animation.flip_h = false
		attackPivot.rotation_degrees = 0
	elif velocity.x < 0:
		animation.flip_h = true
		attackPivot.rotation_degrees = 180
	
	rotation = velocity.y * 20
	rotation *= -1 if animation.flip_h else 1
	animation.rotation_degrees = rotation
	
	
	if attack == false :
		if velocity.x != 0 or velocity.y != 0:
			animation.play("walk")
			if not steps.playing:
				steps.play() 
		else: 
			pass
			# idle()
			
func idle():
	animation.play("idle")
	hitBox.disabled = true
	attack = false
	steps.stop()


func _on_AttackPivot_body_entered(body):
	yield(get_tree().create_timer(0.4), "timeout")
	body.hurt()
