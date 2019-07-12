extends KinematicBody2D

"""
Nessa nova forma de desenvolver, a gravidade não é mais um valor
constante setado no início do código, ao invés disso, ela será
um valor dinâmico de acordo com as variáveis das configurações
do pulo do personagem.
Desta forma, fica mais fácil ter controle da altura mínima e máxima
que o player pode pular, assim como ter uma noção exata da distância
máxima que ele pode alcançar em um pulo.
"""

# O player irá andar 5 blocos por segundo
const SPEED = 5 * Globals.UNIT_SIZE
# A altura máxima do pulo é de 2.25 blocos
const MAX_JUMP_HEIGHT = 2.25 * Globals.UNIT_SIZE
# A altura mínima do pulo é de 0.8 blocos
const MIN_JUMP_HEIGHT = 0.8 * Globals.UNIT_SIZE
# A duração média do pulo.
const JUMP_DURATION = 0.5

# A variáveis abaixo serão calculadas na função _ready
var gravity
var max_jump_velocity
var min_jump_velocity

var motion : Vector2 = Vector2()
var can_control : bool = true;

func _ready():
	# Aqui que a magia matemática é feita:
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
	if Input.is_action_pressed("mv_right"):
		motion.x = SPEED
	elif Input.is_action_pressed("mv_left"):
		motion.x = -SPEED
	else:
		motion.x = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		motion.y = max_jump_velocity
	if Input.is_action_just_released("jump") and motion.y < min_jump_velocity:
		motion.y = min_jump_velocity

func animate():
	if motion.x < 0:
		$Sprite.flip_h = true
	if motion.x > 0:
		$Sprite.flip_h = false
