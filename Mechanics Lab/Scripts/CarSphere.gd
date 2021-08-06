extends Spatial


onready var sphere = $Sphere
onready var car_mesh = $suv
onready var ground_raycast = $suv/RayCast
onready var body_mesh = $suv/tmpParent/suv/body
onready var right_wheel = $suv/tmpParent/suv/wheel_frontRight
onready var left_wheel = $suv/tmpParent/suv/wheel_frontLeft

var sphere_offset = Vector3(0, -1.0, 0)

var acceleration: int = 50
# Turn amount, in degrees
var steering: float = 21.0
# How quickly the car turns
var turn_speed: int = 5
# Below this speed, the car doesn't turn
var turn_stop_limit: float = 0.75
# Ammount to tilt the body on turns
var body_tilt: int = 35

var speed_input = 0
var rotate_input = 0


func _ready():
	# Ground raycast must not detect the sphere
	ground_raycast.add_exception(sphere)


func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = sphere.transform.origin + sphere_offset
	# Accelerate based on car's forward direction
	sphere.add_central_force(-car_mesh.global_transform.basis.z * speed_input)


func _process(delta):
	# Can't steer or accelerate when the car is in the air
	if not ground_raycast.is_colliding():
		return

	# Get accelerate and brake inputs
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration

	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)

	# Rotate wheels for effect
	right_wheel.rotation.y = rotate_input
	left_wheel.rotation.y = rotate_input

	# Rotate car mesh
	if sphere.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(
			car_mesh.global_transform.basis.y,
			rotate_input
		)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(
			new_basis,
			turn_speed * delta
		)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()

		# Tilt body for effect
		var tilt = -rotate_input * sphere.linear_velocity.length() / body_tilt
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, tilt, 10 * delta)

	# Allign car with ground
	var normal = ground_raycast.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, normal.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)


func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
