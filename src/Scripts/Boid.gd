extends KinematicBody2D

export var target_path : NodePath
onready var target = get_node(target_path)
export var max_vel : float = 200.0
export var vax_force : float = 1000.0
var velocity : Vector2
var force : Vector2
var steering_force : Vector2

export (String, "steering", "steering and arriving", "fleeing", "wander", "pursuit") var mode = "steering"
# -------------------------------------------------------------------
func _physics_process(delta):
	if mode == "steering":
		force = steering(global_position, target.global_position, velocity)
		
	velocity = move_and_slide(velocity + force)

# -------------------------------------------------------------------
func steering(cur_pos, target_pos, cur_vel) -> Vector2:
	var distance_to_target : Vector2 = target_pos - cur_pos
	var desired_vel : Vector2 = distance_to_target.normalized() * max_vel
	steering_force = (desired_vel - cur_vel)
#	steering_force = truncate( steering_force, max_force )
	return steering_force
