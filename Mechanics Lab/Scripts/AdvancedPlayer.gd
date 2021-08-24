extends KinematicBody2D


const UNIT_SIZE = 64
# Character will walk 5 blocks per second
const SPEED = 5 * UNIT_SIZE
# The maximum height your character will jump is 2.25 blocks
const MAX_JUMP_HEIGHT = 2.25 * UNIT_SIZE
# The minimum height your character will jump is 0.8 blocks
const MIN_JUMP_HEIGHT = 0.8 * UNIT_SIZE
# Each jump will take 0.5 seconds
const JUMP_DURATION = 0.5

onready var sprite: Sprite = $Sprite
onready var animator: AnimationPlayer = $AnimationPlayer
onready var tween: Tween = $Tween

export var squash: float

var gravity: float
var max_jump_velocity: float
var min_jump_velocity: float
var motion: Vector2 = Vector2()
var can_control: bool = true
var looking_to_right: bool = true
var was_grounded: bool

signal player_flipped(direction)


func _ready():
	# Here's all the magic calcs
	gravity = 2 * MAX_JUMP_HEIGHT / pow(JUMP_DURATION, 2)
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT)
	min_jump_velocity = -sqrt(2 * gravity * MIN_JUMP_HEIGHT)


func _physics_process(delta):
	motion.y += gravity * delta
	if can_control:
		control()
	animate()
	motion = move_and_slide(motion, Vector2(0, -1))


func control() -> void:
	if Input.is_action_pressed("right"):
		motion.x = SPEED
	elif Input.is_action_pressed("left"):
		motion.x = -SPEED
	else:
		motion.x = 0

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		was_grounded = false
		motion.y = max_jump_velocity
		squash_jump()
	elif is_on_floor() and !was_grounded:
		squash_landed()
		was_grounded = true

	if Input.is_action_just_released("jump") and motion.y < min_jump_velocity:
		motion.y = min_jump_velocity


func animate() -> void:
	if motion.x != 0:
		animator.play("Walking")
	else:
		animator.play("Idle")
	if !is_on_floor():
		animator.play("Jumping")
	if motion.x < 0 and looking_to_right:
		sprite.flip_h = true
		emit_signal("player_flipped", "left")
		looking_to_right = false
	if motion.x > 0 and not looking_to_right:
		sprite.flip_h = false
		emit_signal("player_flipped", "right")
		looking_to_right = true


func squash_landed() -> void:
	tween.interpolate_property(
		sprite,
		"scale",
		Vector2(1+squash, 1-squash),
		Vector2(1, 1),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.start()


func squash_jump() -> void:
	tween.interpolate_property(
		sprite,
		"scale",
		Vector2(1-squash,1+squash),
		Vector2(1,1),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.start()
