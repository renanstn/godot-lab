extends KinematicBody2D


const UP = Vector2(0, -1)
const GRAVITY = 15
const JUMP = 700

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer

export var speed: int = 200

var motion: Vector2 = Vector2()


func _physics_process(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(transformInputsToMotion(), UP)
	animate()


func transformInputsToMotion() -> Vector2:
	if Input.is_action_pressed("right"):
		motion.x = speed
	elif Input.is_action_pressed("left"):
		motion.x = -speed
	else:
		motion.x = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		motion.y = -JUMP
	return motion


func animate():
	if !is_on_floor():
		if abs(motion.y) > JUMP / 2:
			if motion.y < 0:
				animator.play("Jump_up")
			else:
				animator.play("Jump_down")
		else:
			animator.play("Jump_roll")
	else:
		if motion.x != 0:
			# Insert walking animation here
			pass
		else:
			animator.play("Idle")
