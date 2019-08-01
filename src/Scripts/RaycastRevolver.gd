extends Node2D

onready var raycast : RayCast2D = get_node("Base/RayCast2D")
var explosion = preload("res://Scenes/Explosion.tscn")

func _ready():
	var tamanho_tela = get_viewport().get_visible_rect().size
	raycast.set_cast_to(Vector2(0, tamanho_tela.x))

func _physics_process(delta):
	# Sempre olhar para o mouse:
	$Base.set_rotation(get_local_mouse_position().angle())
	
	# Correção quando o objeto está a direita do mouse:
	if position.x < get_local_mouse_position().x:
		$Base.set_scale(Vector2(1, 1))
	else:
		$Base.set_scale(Vector2(1, -1))

	if Input.is_action_just_pressed("fire"):
		var acertou = raycast.get_collider()
		if acertou:
			var clone_explosion = explosion.instance()
			var ponto_de_colisao = raycast.get_collision_point()
			# Criar explosao
			clone_explosion.set_global_position(ponto_de_colisao)
			get_parent().get_parent().add_child(clone_explosion)
