extends RigidBody2D


onready var raycast : RayCast2D = get_parent().get_node("RayCast2D")

var rotate: float = 0
var deacceleration = 10
var brake_power = 50
var brake: bool = false
var jump: bool = false
var accelerate_right: bool = false
var accelerate_left: bool = false
var on_ground: bool = false


func _physics_process(_delta):
	raycast.set_position(Vector2(position.x, position.y))
	if accelerate_right:
		rotate += 10
		rotate = clamp(rotate, -1000, 1000)
		apply_torque_impulse(rotate)
	elif accelerate_left:
		rotate -= 10
		rotate = clamp(rotate, -1000, 1000)
		apply_torque_impulse(rotate)
	else: # Deaccelerate
		if rotate > 0:
			rotate -= deacceleration
		elif rotate < 0:
			rotate += deacceleration
		else:
			rotate = 0
	if jump:
		apply_impulse(Vector2(0, 0), Vector2(0, -500))
		jump = false


func _process(_delta):
	# Check inputs
	if Input.is_action_pressed("right"):
		accelerate_right = true
	elif Input.is_action_pressed("left"):
		accelerate_left = true
	else:
		accelerate_right = false
		accelerate_left = false
	if Input.is_action_just_pressed("jump") and raycast.is_colliding():
		jump = true
