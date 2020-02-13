extends KinematicBody2D

export(float) var squash
var was_grounded = false
var velocity = Vector2.ZERO
var jump_height = 300.0
onready var tween = $Tween
onready var mask = $Sprite
const gravity = 7.0

func _physics_process(delta):
	if is_on_floor() && !was_grounded:
		squash_landed()
	was_grounded = is_on_floor()
	velocity.y += gravity
	if Input.is_action_just_pressed("jump"):
		was_grounded = false
		velocity.y -= jump_height
		squash_jump()
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
