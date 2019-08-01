extends Node2D

onready var raycast : RayCast2D = get_node("Base/RayCast2D")
var explosion = preload("res://Scenes/Explosion.tscn")
var can_fire : bool = true
# -------------------------------------------------------------------
func _ready():
	adjust_raycast_size()

func _physics_process(delta):
	look_to_the_mouse()
	if Input.is_action_just_pressed("fire"):
		if can_fire:
			shot()
		else:
			shoot_fail()
# -------------------------------------------------------------------
func adjust_raycast_size():
	var tamanho_tela = get_viewport().get_visible_rect().size
	raycast.set_cast_to(Vector2(0, tamanho_tela.x))

func look_to_the_mouse():
	$Base.set_rotation(get_local_mouse_position().angle())
	# Correção quando o objeto está a direita do mouse:
	if position.x < get_local_mouse_position().x:
		$Base.set_scale(Vector2(1, 1))
	else:
		$Base.set_scale(Vector2(1, -1))

func shot():
	can_fire = false
	$RecoilTimer.start()
	$BangSound.play()
	var acertou = raycast.get_collider()
	if acertou:
		var clone_explosion = explosion.instance()
		var ponto_de_colisao = raycast.get_collision_point()
		var colidiu_com = raycast.get_collider()
		var collider_groups = colidiu_com.get_groups()
		if "enemy" in collider_groups:
			print("hit enemy!")
		# Criar explosao
		clone_explosion.set_global_position(ponto_de_colisao)
		clone_explosion.set_rotation_degrees(rand_range(0, 360))
		get_parent().get_parent().add_child(clone_explosion)

func shoot_fail():
	$ClickSound.play()

func _on_RecoilTimer_timeout():
	can_fire = true
