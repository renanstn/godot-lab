extends Node2D

onready var raycast : RayCast2D = get_node("Base/RayCast2D")

func _ready():
	var tamanho_tela = get_viewport().get_visible_rect().size
	raycast.set_cast_to(Vector2(0, tamanho_tela.x))

func _physics_process(delta):
	if Input.is_action_just_pressed("rewind_time"):
		print("Bang!")
		print(raycast.get_collider())
		print(raycast.get_collision_point())