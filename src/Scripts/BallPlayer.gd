extends RigidBody2D

var rotate : float = 0
var taxa_de_desaceleracao = 10
var brake : bool = false
var jump : bool = false
var accelerate : bool = false
var on_ground : bool = false
var space_state : Physics2DDirectSpaceState
var ground_check

func _ready():
	ground_check = get_parent().get_node("GroundCheck")

func _physics_process(delta):
	# Configurações necessárias para usar o raycast
	space_state = get_world_2d().direct_space_state

	getInputs()
	check_ground()
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

	print(accelerate)
	print(brake)
	print(jump)
	print(rotate)
	print(on_ground)

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
	if Input.is_action_pressed("jump"):
		brake = true
	else:
		brake = false
	# Jump
	if Input.is_action_just_pressed("rewind_time") and not on_ground:
		jump = true
		
func check_ground():
	ground_check.set_position(Vector2(position.x, position.y + 40))
	var colisoes = space_state.intersect_ray(global_position, ground_check.global_position)
	on_ground = colisoes.size() == 0