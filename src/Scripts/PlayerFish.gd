extends KinematicBody2D

const MAX_SPEED : float = 300.0
const ACCEL : float = 0.02
var velocity : Vector2

func _physics_process(delta):
	velocity = smooth_move()
	velocity = move_and_slide(velocity)
	direct_sprite()
	
func smooth_move() -> Vector2:
	# Direita / Esquerda
	if Input.is_action_pressed("mv_right"):
		velocity.x = lerp(velocity.x, MAX_SPEED, ACCEL)
	elif Input.is_action_pressed("mv_left"):
		velocity.x = lerp(velocity.x, -MAX_SPEED, ACCEL)
	else:
		velocity.x = lerp(velocity.x, 0, ACCEL)
		
	# Cima / Baixo
	if Input.is_action_pressed("mv_up"):
		velocity.y = lerp(velocity.y, -MAX_SPEED, ACCEL)
	elif Input.is_action_pressed("mv_down"):
		velocity.y = lerp(velocity.y, MAX_SPEED, ACCEL)
	else:
		velocity.y = lerp(velocity.y, 0, ACCEL)
		
	return velocity

func direct_sprite() -> void:
	if velocity.x >= 0:
		$Sprite.set_scale(Vector2(1, 1))
		$Sprite.set_rotation(velocity.angle())
	else:
		$Sprite.set_scale(Vector2(-1, 1))
		$Sprite.set_rotation(velocity.angle() - PI)
