extends Node2D

export var explosion_scene = preload("res://Scenes/Explosion.tscn")
export var rastro_scene = preload("res://Scenes/Rastro.tscn")
onready var raycast : RayCast2D = get_node("Base/RayCast2D")
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

func _on_RecoilTimer_timeout() -> void:
	""" Ativa a variável para poder atirar novamente. """
	can_fire = true
	$ReloadSound.play()

# -------------------------------------------------------------------
func adjust_raycast_size() -> void:
	# Ajusta o tamanho do raycast para ocupar a tela toda.
	var tamanho_tela = get_viewport().get_visible_rect().size
	raycast.set_cast_to(Vector2(0, tamanho_tela.x))

func look_to_the_mouse() -> void:
	""" Faz com que a arma sempre esteja apontada para o mouse. """
	$Base.set_rotation(get_local_mouse_position().angle())
	# Inverter a imagem quando o objeto está a direita do mouse:
	if position.x < get_local_mouse_position().x:
		$Base.set_scale(Vector2(1, 1))
	else:
		$Base.set_scale(Vector2(1, -1))

func shot() -> void:
	""" Atira utilizando a mecanica de raycast. """
	can_fire = false
	$RecoilTimer.start()
	$BangSound.play()
	var acertou_algo = raycast.get_collider()
	if acertou_algo:
		var ponto_de_colisao = raycast.get_collision_point()
		var colidiu_com = raycast.get_collider()
		var collider_groups = colidiu_com.get_groups()
		criar_rastro($Base/RayCast2D.get_global_position(), ponto_de_colisao)
		if "enemy" in collider_groups:
			print("hit enemy!")
			# Adicione aqui o signal de dar hit no inimigo
		criar_animacao_hit(ponto_de_colisao)

func shoot_fail() -> void:
	""" Apenas executa o som de miss shoot. """
	$ClickSound.play()

func criar_animacao_hit(ponto_de_colisao : Vector2) -> void:
	""" Cria a animação de hit no ponto de colisão. """
	var clone_explosion = explosion_scene.instance()
	clone_explosion.set_global_position(ponto_de_colisao)
	clone_explosion.set_rotation_degrees(rand_range(0, 360))
	get_parent().get_parent().add_child(clone_explosion)

func criar_rastro(origem : Vector2, destino : Vector2) -> void:
	""" Cria o rastro do tiro no ar. """
	var rastro_clone = rastro_scene.instance()
	rastro_clone.setup(origem, destino)
	get_parent().get_parent().add_child(rastro_clone)
