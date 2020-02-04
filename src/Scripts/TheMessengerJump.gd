extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 15
const JUMP = 600

export(int) var speed = 200

var motion : Vector2 = Vector2()

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer


func _physics_process(delta)->void:
	motion.y += GRAVITY
	motion = move_and_slide(fromInputsToMotion(), UP)
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


func animate():
	if !is_on_floor():
		if abs(motion.y) > JUMP / 2:
			animator.play("JumpB")
		else:
			animator.play("JumpA")
	else:
		if motion.x != 0:
			animator.play("Walking")
		else:
			animator.play("Idle")