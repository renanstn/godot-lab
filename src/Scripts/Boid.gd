extends KinematicBody2D

export var target_path : NodePath
export (String, "steering", "steering and arriving", "fleeing", "wander", "pursuit") var mode = "steering"
onready var target = get_node(target_path)
export var max_vel : float = 200.0
var velocity : Vector2
var force : Vector2
var steering_force : Vector2
# -------------------------------------------------------------------
func _physics_process(delta):
	if mode == "steering":
		force = steering(global_position, target.global_position, velocity)
	elif mode == "steering and arriving":
		force = steering_and_arrive(global_position, target.global_position, velocity, 200)
	elif mode == "fleeing":
		force = fleeing(global_position, target.global_position, velocity, 200)
	elif mode == "wander":
		force = wander(velocity, 100, 50)
	elif mode == "pursuit":
		force = pursuit(global_position, target.global_position, velocity, target.velocity)
	
	velocity = move_and_slide(velocity + force)

# -------------------------------------------------------------------
func steering(current_position, target_pos, cur_vel) -> Vector2:
	var distance_to_target : Vector2 = target_pos - current_position
	var desired_vel : Vector2 = distance_to_target.normalized() * max_vel
	steering_force = desired_vel - cur_vel
	return steering_force
	
# Essa função não está funcionando direito
func pursuit(current_position, target_pos, cur_vel, target_vel) -> Vector2:
	return steering(current_position + target_vel, target_pos, cur_vel)

func steering_and_arrive(current_position, target_position, current_velocity, min_distance) -> Vector2:
	var distance_to_target : Vector2 = target_position - current_position
	var desired_vel : Vector2 = distance_to_target.normalized() * max_vel
	if distance_to_target.length() <= min_distance:
		desired_vel *= distance_to_target.length() / min_distance
		steering_force = desired_vel - current_velocity
	else:
		steering_force = desired_vel - current_velocity
	return steering_force

func fleeing(current_position, target_position, current_velocity, min_distance) -> Vector2:
	var distance_to_target : Vector2 = target_position - current_position
	if distance_to_target.length() > min_distance:
		return Vector2(0, 0)
	var desired_vel : Vector2 = -distance_to_target.normalized() * max_vel
	steering_force = desired_vel - current_velocity
	return steering_force

func wander(current_velocity, cdist, cradius) -> Vector2:
	var circle_center = current_velocity.normalized() * cdist
	var wander_vector = Vector2(cradius, 0).rotated(randf() * 2 * PI)
	steering_force = circle_center + wander_vector
	return steering_force
	
	
	
	
	
	