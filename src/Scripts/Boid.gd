extends Node2D

export var target_path : NodePath
export (String, "steering", "steering and arriving", "fleeing", "wander", "pursuit") var mode : String = "steering"
export (String, "off", "steering", "fleeing", "wander") var flocking : String = "off"
onready var target = get_node(target_path)
var max_velocity : float = 200.0
var max_force : float = 1000.0
var velocity : Vector2
var force : Vector2
var other_bodies : Array

func _ready():
	other_bodies = get_parent().get_children()
	other_bodies.remove(other_bodies.find(self))

func _physics_process(delta):

	if flocking == "off":

		if mode == "steering":
			force = steering(
				global_position,
				target.global_position,
				velocity,
				delta
			)
		elif mode == "pursuit":
			force = pursuit(
				global_position,
				target.global_position,
				velocity,
				target.velocity,
				delta
			)
		elif mode == "steering and arriving":
			force = steering_and_arrive(
				global_position,
				target.global_position,
				velocity,
				200,
				delta
			)
		elif mode == "fleeing":
			force = fleeing(
				global_position,
				target.global_position,
				velocity,
				200,
				delta
			)
		elif mode == "wander":
			force = wander(velocity, 100, 50)
			
	elif flocking == "steering":

		force = steering(
				global_position,
				target.global_position,
				velocity,
				delta
			)
			
		var other_positions : Array
		var other_velocity : Array
		for body in other_bodies:
			other_positions.append(body.global_position)
			other_velocity.append(body.velocity)
		var flock_force : Vector2
		
		flock_force = flocking(
			global_position,
			velocity,
			other_positions,
			other_velocity,
			30, 200,
			200, 1,
			200, 1
		)
		
		force += flock_force

	velocity += force * delta
	var motion : Vector2 = velocity * delta

	global_position =  global_position + motion

# ==================================================================
# BASIC BEHAVIOURS
# ==================================================================
func steering(
	current_position : Vector2, 
	target_position : Vector2, 
	current_velocity : Vector2, 
	delta : float
) -> Vector2:
	var distance_to_target : Vector2 = target_position - current_position
	var desired_velocity : Vector2 = distance_to_target.normalized() * max_velocity
	var steering_force : Vector2 = (desired_velocity - current_velocity) / delta
	return steering_force

func pursuit(
	current_position : Vector2,
	target_position : Vector2,
	current_velocity : Vector2,
	target_velocity : Vector2,
	delta : float
) -> Vector2:
	return steering(
		current_position + target_velocity * delta,
		target_position,
		current_velocity,
		delta
	)

func steering_and_arrive(
	current_position : Vector2,
	target_position : Vector2,
	current_velocity : Vector2,
	minimal_distance : float,
	delta : float
) -> Vector2:
	var steering_force : Vector2
	var distance_to_target : Vector2 = target_position - current_position
	var desired_velocity : Vector2 = distance_to_target.normalized() * max_velocity
	if distance_to_target.length() <= minimal_distance:
		desired_velocity *= distance_to_target.length() / minimal_distance
		steering_force = (desired_velocity - current_velocity) / delta
	else:
		steering_force = (desired_velocity - current_velocity) / delta
	return steering_force

func fleeing(
	current_position : Vector2,
	target_position : Vector2,
	current_velocity : Vector2,
	minimal_distance : float,
	delta : float
) -> Vector2:
	var distance_to_target : Vector2 = target_position - current_position
	if distance_to_target.length() > minimal_distance:
		return Vector2(0, 0)
	var desired_velocity : Vector2 = -distance_to_target.normalized() * max_velocity
	var steering_force : Vector2 = (desired_velocity - current_velocity) / delta
	return steering_force

func wander(
	current_velocity : Vector2,
	cdist : float,
	cradius : float
) -> Vector2:
	var circle_center = current_velocity.normalized() * cdist
	var wander_vector = Vector2(cradius, 0).rotated(randf() * 2 * PI)
	var steering_force : Vector2 = circle_center + wander_vector
	return steering_force

func flocking(
	current_position : Vector2,
	current_velocity : Vector2,
	other_positions : Array,
	other_velocity : Array,
	separation_distance,
	separation_scaling,
	alignment_distance,
	alignment_scaling,
	cohesion_distance,
	cohesion_scaling
) -> Vector2:
	var separation_force : Vector2 = Vector2(0, 0)
	var separation_counter : int = 0

	var alignment_vel : Vector2 = Vector2( 0, 0 )
	var alignment_counter : int = 0

	var cohesion_center : Vector2 = current_position
	var cohesion_counter : int = 1

	for index in range( other_positions.size() ):
		var distance_vec = other_positions[index] - current_position
		var distance = distance_vec.length()
		
		if distance < separation_distance:
			separation_force -= distance_vec
			separation_counter += 1
		
		if distance < alignment_distance:
			alignment_vel += other_velocity[index]
			alignment_counter += 1
		
		if distance < cohesion_distance:
			cohesion_center += other_positions[index]
			cohesion_counter += 1
		
	if separation_counter > 0: separation_force /= separation_counter
	separation_force *= separation_scaling
	
	if alignment_counter > 0: alignment_vel /= alignment_counter
	var alignment_force = ( alignment_vel - current_velocity ) * alignment_scaling
	
	cohesion_center /= cohesion_counter
	var cohesion_force = ( cohesion_center - current_position ) * cohesion_scaling
	
	var steering_force : Vector2 = separation_force + alignment_force + cohesion_force
	return steering_force


# ==================================================================
# FLOCKING FUNCTIONS
# ==================================================================

func separation(
	current_position : Vector2,
	other_positions : Array,
	scalling,
	minimal_distance : float
) -> Vector2:
	var steering_force : Vector2 = Vector2(0, 0)
	var counter = 0
	for other in other_positions:
		var distance : Vector2 = other - current_position
		if distance.length() < minimal_distance:
			counter += 1
			steering_force -= distance
	if counter > 0:
		steering_force /= counter
	steering_force *= scalling
	return steering_force
	
func alignment(
	current_position : Vector2,
	other_positions : Array,
	current_velocity : Vector2,
	other_velocity : Vector2,
	minimal_distance : float
) -> Vector2:
	var desired_velocity = Vector2()
	var counter = 0
	for index in range(other_positions.size()):
		if ( other_positions[index] - current_position ).length() < minimal_distance:
			desired_velocity += other_velocity[index]
			counter += 1
	if counter > 0: desired_velocity /= counter
	var steering_force : Vector2 = (desired_velocity - current_velocity)
	return steering_force
	
func cohesion(
	current_position : Vector2,
	other_positions : Array,
	scaling : float,
	minimal_distance : float
) -> Vector2:
	var center : Vector2 = current_position
	var counter = 1
	for other in other_positions:
		if (other - current_position).length() < minimal_distance:
			center += other
			counter += 1
	center /= counter
	var steering_force : Vector2 = (center - current_position) * scaling
	return steering_force
