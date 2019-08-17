extends KinematicBody2D

export var max_speed : float = 300.0
export var max_force : float = 0.02
var velocity : Vector2
var target : Vector2

func _physics_process(delta):
	target = get_global_mouse_position()
	velocity = steer(target)
	move_and_slide(velocity)
	aligment()
	
func steer(target : Vector2) -> Vector2:
	var vector = (target - get_position()).normalized() * max_speed
	var desired_velocity = Vector2(vector.x, vector.y)
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * max_force)
	return target_velocity

func aligment() -> Vector2:
	var velocity_to_return : Vector2 = Vector2()
	var vizinhos : Array = []
	vizinhos = $Vizinhos.get_overlapping_bodies()
	for vizinho in vizinhos:
		if not vizinho.is_in_group('boid'):
			var distancia : float = get_global_position().distance_to(vizinho.get_global_position())
			if distancia < 100:
				velocity_to_return.x += vizinho.velocity.x
				velocity_to_return.y += vizinho.velocity.y
				velocity_to_return.x /= vizinhos.size()
				velocity_to_return.y /= vizinhos.size()

	return velocity_to_return.normalized()