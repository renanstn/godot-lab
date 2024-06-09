extends KinematicBody2D


const UP = Vector2(0, -1)
const GRAVITY = 15
const JUMP = 500

export var speed : int = 200

var motion : Vector2 = Vector2()
var covered : bool = false
var can_cover : bool = false

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer

signal player_flipped(direction)


func _physics_process(_delta) -> void:
	motion.y += GRAVITY
	motion = move_and_slide(convertInputsToMotion(), UP)
	animate()


func convertInputsToMotion() -> Vector2:
	if Input.is_action_pressed("right"):
		motion.x = speed
	elif Input.is_action_pressed("left"):
		motion.x = -speed
	else:
		motion.x = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		motion.y = -JUMP
	if is_on_floor() and Input.is_action_just_pressed("cover") and can_cover:
		covered = true
		sprite.modulate.r = 0.4
		sprite.modulate.g = 0.4
		sprite.modulate.b = 0.4
	elif Input.is_action_just_released("cover"):
		covered = false
		sprite.modulate.r = 1
		sprite.modulate.g = 1
		sprite.modulate.b = 1
	return motion


func animate() -> void:
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
	if covered == true:
		animator.play("Cover")
