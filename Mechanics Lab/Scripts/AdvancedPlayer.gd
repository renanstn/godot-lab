extends KinematicBody2D


"""
In this new player script, gravity is not a fixed value chosen by you.
Instead, you set the UNIT SIZE of the blocks of your tilemap, and all values
will be calculated according to your blocks.
This way, it's more easy to control how hight (in blocks) you wan't your
character reach in a jump, and how long (in blocks too) your character can jump.
"""

const UNIT_SIZE = 64
# Character will walk 5 blocks per second
const SPEED = 5 * UNIT_SIZE
# The maximum height your character will jump is 2.25 blocks
const MAX_JUMP_HEIGHT = 2.25 * UNIT_SIZE
# The minimum height your character will jump is 0.8 blocks
const MIN_JUMP_HEIGHT = 0.8 * UNIT_SIZE
# Each jump will take 0.5 seconds
const JUMP_DURATION = 0.5

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer

var gravity: float
var max_jump_velocity: float
var min_jump_velocity: float
var motion: Vector2 = Vector2()
var can_control: bool = true
var looking_to_right: bool = true

signal player_flipped(direction)


func _ready():
	# Here's al the magic calcs
	gravity = 2 * MAX_JUMP_HEIGHT / pow(JUMP_DURATION, 2)
	max_jump_velocity = -sqrt(2 * gravity * MAX_JUMP_HEIGHT)
	min_jump_velocity = -sqrt(2 * gravity * MIN_JUMP_HEIGHT)


func _physics_process(delta):
	motion.y += gravity * delta
	if can_control:
		control()
		animate()
	motion = move_and_slide(motion, Vector2(0, -1))


func control():
	if Input.is_action_pressed("right"):
		motion.x = SPEED
	elif Input.is_action_pressed("left"):
		motion.x = -SPEED
	else:
		motion.x = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		motion.y = max_jump_velocity
	if Input.is_action_just_released("jump") and motion.y < min_jump_velocity:
		motion.y = min_jump_velocity


func animate():
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
