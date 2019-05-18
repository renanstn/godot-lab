extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const JUMP = 500

export var speed : int = 200
var motion : Vector2 = Vector2()
var can_control : bool = true

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer

signal player_flipped(direction)


func _physics_process(delta)->void:
	if can_control:
		motion.y += GRAVITY
		motion = move_and_slide(fromInputsToMotion(), UP)
	$Pivot.look_at(get_global_mouse_position())
	animate()

func fromInputsToMotion()->Vector2:

	if Input.is_action_pressed("mv_right"):
		motion.x = speed
	elif Input.is_action_pressed("mv_left"):
		motion.x = -speed
	else:
		motion.x = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		motion.y = -JUMP

	return motion

func animate()->void:
	if motion.x != 0:
		animator.play("Walking")
	else:
		animator.play("Idle")		
	if !is_on_floor():
		animator.play("Jumping")
	if motion.x > 0 and sprite.flip_h:
		sprite.flip_h = false
		emit_signal("player_flipped", "right")
	if motion.x < 0 and !sprite.flip_h:
		sprite.flip_h = true
		emit_signal("player_flipped", "left")
