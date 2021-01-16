extends KinematicBody2D

var speed = 700
var attack
var converting = false
var converted = false
var blocked = false

onready var animation = get_node("AnimatedSprite")
onready var attackPivot = get_node("AttackPivot")
onready var hitBox = get_node("AttackPivot/Hitbox")
onready var anger = get_node("Anger")
onready var steps = get_node("Steps")
onready var objects = get_node("AnimatedSprite2")

const TRANSFORMS = ["Grass01", "Grass02", "Grass03", "Grass04", "Grass05", "Grass06", "Grass07", "Grass08", "Graveyard01", 
	"Rock01", "Rock02", "Rock03", "Rock04", "Rock05", "Rock06", "Rock07", "Rock08", "Rock09", "Rock10", "Rock11", "Rock12", 
	"Rune01", "Rune02", "Rune03", "Rune04", "Rune05", "Rune06", "Rune07", "Skull01", "Skull02", "Skull03", "Spikes01", 
	"Stump01", "Stump02", "Stump03", "Tree01", "Tree02", "Tree03"]

func _ready():
	set_process_input(false)
	set_process_unhandled_input(true)
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
			do_attack()
	
	move_and_slide(velocity.normalized() * speed) 
	player_animation(velocity)
	
	
	if Input.is_action_pressed("ui_convert"):
		if not converting:
			if converted:
				roll_back()
			else:
				speed = 10
				animation.visible = false
				objects.animation = get_random_texture()
				objects.visible = true
				converted = true
				converting = true
				$ConvertedTimer.start()
				$ConvertingTimer.start()


func get_random_texture():
	return TRANSFORMS[randi() % TRANSFORMS.size()]


func roll_back():
	speed = 700
	objects.visible = false
	animation.visible = true
	converted = false
	converting = true
	if $BlockedTimer.time_left > 0 : $BlockedTimer.stop()
	if $ConvertingTimer.time_left > 0 : $ConvertingTimer.stop()
	if $ConvertedTimer.time_left > 0 : $ConvertedTimer.stop()
	$BlockedTimer.start()


func do_attack():
	if not converted:
		attack = true
		hitBox.disabled = false
		animation.play("attack")
		if not anger.playing:
			anger.play() 


func player_animation(velocity):
	var rotation = 0
	
	if velocity.x > 0:
		animation.flip_h = false
		attackPivot.rotation_degrees = 0
	elif velocity.x < 0:
		animation.flip_h = true
		attackPivot.rotation_degrees = 180
	
	rotation = velocity.y * 6
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
	if "Tree" in body.get_name():
		body.hurt()


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed and not attack:
			do_attack()


func _on_ConvertedTimer_timeout():
	roll_back()


func _on_ConvertingTimer_timeout():
	converting = false


func _on_BlockedTimer_timeout():
	converting = false
