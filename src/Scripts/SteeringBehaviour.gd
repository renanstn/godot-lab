extends KinematicBody2D

"""
Steering Behaviour Seek e Flee implementados.
- Lembre-se que na godot 3 o set_fixed_process(true)
e fixed_process(delta) foram substituídos pelo 
_physics_process().
- Da mesma forma, o move() foi subatituído pelo move_and_slide()
- O construtor do Vector2 espera 2 valores (x e y), então não
funciona mais passar um Vector2 diretamente pra ele.
- Max speed é a velocidade que o objeto irá alcancar
- Max force é a suavidade com que ele faz as curvas
"""

export var max_speed : float = 300.0
export var max_force : float = 0.02
export (int, "Seek", "Flee") var mode = 0
var velocity : Vector2
var target : Vector2

func _physics_process(delta):
	target = get_global_mouse_position()
	velocity = steer(target)
	move_and_slide(velocity)

func steer(target : Vector2) -> Vector2:
	var vector = (target - get_position()).normalized() * max_speed
	var desired_velocity = Vector2(vector.x, vector.y)
	if mode == 1: # Flee
		desired_velocity = -desired_velocity
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * max_force)
	return target_velocity
