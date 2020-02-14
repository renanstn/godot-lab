extends KinematicBody2D

export(float) var squash
var was_grounded = false
var velocity = Vector2.ZERO
var jump_height = 500.0
var speed = 300.0
onready var tween = $Tween
onready var mask = $Sprite
const gravity = 12.0

func _physics_process(delta):
	if is_on_floor() and !was_grounded:
		squash_landed()
	was_grounded = is_on_floor()
	velocity.y += gravity
	if Input.is_action_pressed("mv_right"):
		velocity.x = speed
	elif Input.is_action_pressed("mv_left"):
		velocity.x = -speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("jump"):
		was_grounded = false
		squash_jump()
		velocity.y -= jump_height
	velocity = move_and_slide(velocity, Vector2.UP)
	
func squash_landed():
	tween.interpolate_property(
		mask,
		"scale",
		Vector2(1+squash, 1-squash),
		Vector2(1, 1),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.start()
	
func squash_jump():
	tween.interpolate_property(
		mask,
		"scale",
		Vector2(1-squash,1+squash),
		Vector2(1,1),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.start()
