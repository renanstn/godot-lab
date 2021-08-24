extends Node2D


onready var fire_point: Position2D = $ShootPoint
onready var capsule_ejector: Position2D = $EjectCapsulePoint
onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
onready var reload_sound: AudioStreamPlayer2D = $ReloadSound
onready var empty_bullets_sound: AudioStreamPlayer2D = $EmptyBulletsSound
onready var recoil_timer: Timer = $RecoilTimer
onready var reload_timer: Timer = $ReloadTimer

export var hit_animation_scene: PackedScene
export var bullet_trail_scene: PackedScene
export var capsule_scene: PackedScene
export(int, "Automatic", "SemiAutomatic") var gun_type
export(int, 1, 1000) var bullet_damage
export(float, 0, 1) var spread_rate
export(float, 0, 5) var recoil_time
export(int, 1, 1000) var max_bullets
export(float, 0, 10) var reload_time
export(bool) var auto_reload

var can_fire: bool = true
var reloading: bool = false
var bullets: int
var raycast: RayCast2D

signal shoot
signal reloading
signal reloaded
signal hit_enemy
signal no_bullets
signal ready_to_fire
signal update_bullets(how_many)
signal cause_damage(how_much)


func _ready():
	bullets = max_bullets
	create_raycast()
	adjust_raycast_size()
	emit_signal("update_bullets", bullets)


func _process(_delta):
	look_to_mouse()
	if gun_type == 0: # Automatic
		if can_fire and Input.is_action_pressed("mouse_left"):
			if bullets > 0:
				shoot()
			else:
				empty_bullets()
	elif gun_type == 1: # Semi automatic
		if can_fire and Input.is_action_just_pressed("mouse_left"):
			if bullets > 0:
				shoot()
			else:
				empty_bullets()

	if Input.is_action_just_pressed("reload") and not reloading:
		reload_start()

	# Auto reload
	if auto_reload and bullets < 1 and not reloading:
		reload_start()


func look_to_mouse() -> void:
	look_at(get_global_mouse_position())
	# Invert Y axis to avoid the gun to be upside down
	if global_position.x < get_global_mouse_position().x:
		set_scale(Vector2(1, 1))
	else:
		set_scale(Vector2(1, -1))


func create_raycast() -> void:
	raycast = RayCast2D.new()
	raycast.position = fire_point.position
	raycast.rotation_degrees = -90
	raycast.enabled = true
	add_child(raycast)


func adjust_raycast_size() -> void:
	var size_screen : Vector2 = get_viewport().get_visible_rect().size
	raycast.set_cast_to(Vector2(0, size_screen.x))


func spread_bullet() -> void:
	# 22.5 degrees it's half of 45. 45 It's the max spread allowed.
	var spread_angle : float = 22.5 * spread_rate
	# Reset raycast angle before each fire.
	raycast.rotation_degrees = -90
	raycast.rotation_degrees += rand_range(-spread_angle, spread_angle)


func shoot() -> void:
	shoot_sound.play()
	emit_signal("shoot")
	bullets -= 1
	emit_signal("update_bullets", bullets)
	can_fire = false
	recoil_timer.start()
	spread_bullet()
	eject_capsule()
	var hit_something = raycast.get_collider()
	if hit_something:
		var collision_point = raycast.get_collision_point()
		var collide_with = raycast.get_collider()
		var collider_groups = collide_with.get_groups()
		create_trail(raycast.get_global_position(), collision_point)
		if "enemy" in collider_groups:
			emit_signal("hit_enemy")
			emit_signal("cause_damage", bullet_damage)
		create_hit_animation(collision_point)


func reload_start() -> void:
	reloading = true
	can_fire = false
	reload_timer.start()
	reload_sound.play()
	emit_signal("reloading")


func empty_bullets() -> void:
	empty_bullets_sound.play()
	emit_signal("no_bullets")


func create_trail(to: Vector2, from: Vector2) -> void:
	var trail = bullet_trail_scene.instance()
	trail.setup(to, from)
	get_parent().add_child(trail)


func create_hit_animation(collision_point: Vector2) -> void:
	var hit_animation = hit_animation_scene.instance()
	hit_animation.global_position = collision_point
	hit_animation.rotation_degrees = rand_range(0, 360)
	get_parent().add_child(hit_animation)


func eject_capsule() -> void:
	var capsule = capsule_scene.instance()
	# Variável que auxilia a correção do ângulo caso o
	# braço esteja com a escala invertida
	capsule.global_position = capsule_ejector.global_position
	capsule.rotation = capsule_ejector.global_rotation * scale.y
	capsule.apply_impulse(Vector2(0,0), Vector2(-100 * scale.y,-200))
	capsule.add_torque(-500 * scale.y)
	get_parent().add_child(capsule)


func _on_RecoilTimer_timeout():
	can_fire = true
	emit_signal("ready_to_fire")


func _on_ReloadTimer_timeout():
	reloading = false
	bullets = max_bullets
	can_fire = true
	emit_signal("reloaded")
	emit_signal("update_bullets", bullets)
