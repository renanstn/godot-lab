extends KinematicBody2D

export var max_speed : float = 300.0
export var max_force : float = 0.02
export var max_see_ahead : float = 200
export var max_avoid_force : float = 0.05
var velocity : Vector2
var target : Vector2
var distance : Vector2

func _physics_process(delta):
	target = get_global_mouse_position()
	velocity = steer(target)
	$Ahead.position = velocity.normalized() * max_see_ahead
	$Ahead2.position = velocity.normalized() * max_see_ahead * 0.5
	$RayCastAhead.set_cast_to($Ahead.position)
	$RayCastAhead2.set_cast_to($Ahead2.position)
	velocity += check_collision()
	move_and_slide(velocity)

func steer(target : Vector2) -> Vector2:
	var vector = (target - get_position()).normalized() * max_speed
	var desired_velocity = Vector2(vector.x, vector.y)
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * max_force)
	return target_velocity

func check_collision() -> Vector2:
	if $RayCastAhead.is_colliding() or $RayCastAhead2.is_colliding():
		var avoidance_force = $Ahead.position - $RayCastAhead.get_collider().position
		avoidance_force = avoidance_force.normalized() * max_avoid_force
		return avoidance_force
	else:
		return Vector2(0,0)