extends RigidBody2D

var rotate : float = 0
var taxa_de_desaceleracao = 10
var brake : bool = false
var jump : bool = false
var accelerate : bool = false
var on_ground : bool = false
onready var raycast : RayCast2D = get_parent().get_node("RayCast2D")

func _physics_process(delta):

	raycast.set_position(Vector2(position.x, position.y))
	getInputs()
	if not brake:
		if accelerate:
			rotate = clamp(rotate, -1000, 1000)
			apply_torque_impulse(rotate)
		else: # Desacelerar
			if rotate > 0:
				rotate -= taxa_de_desaceleracao
			elif rotate < 0:
				rotate += taxa_de_desaceleracao
			else:
				rotate = 0
	else:
		rotate = 0
	if jump:
		apply_impulse(Vector2(0, 0), Vector2(0, -500))
		jump = false

func getInputs():
	# Accelerate
	if Input.is_action_pressed("mv_right"):
		accelerate = true
		rotate += 10
	elif Input.is_action_pressed("mv_left"):
		accelerate = true
		rotate -= 10
	else:
		accelerate = false
	# Brake
	if Input.is_action_pressed("rewind_time"):
		brake = true
	else:
		brake = false
	# Jump
	if Input.is_action_just_pressed("jump") and raycast.is_colliding():
		jump = true
