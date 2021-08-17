extends Position2D


# In my sprite, the spear is faced up, so I must apply a 90 degrees offset
# to fix the direction
const SPRITE_ROTATION_OFFSET = 90
export var spear_scene: PackedScene
export var teleport_effect: PackedScene
export var throw_speed: float = 800
onready var sprite = $Sprite
var can_throw = true
var spear

signal reload


func _process(_delta):
	if can_throw:
		if Input.is_action_pressed("mouse_left"):
			sprite.visible = true
			sprite.look_at(get_global_mouse_position())
			sprite.rotation = sprite.rotation + deg2rad(SPRITE_ROTATION_OFFSET)
		elif Input.is_action_just_released("mouse_left"):
			sprite.visible = false
			throw_spear()
			can_throw = false
	else:
		if Input.is_action_just_pressed("mouse_right"):
			teletransport()
			can_throw = true
	if Input.is_action_just_pressed("reload"):
		emit_signal("reload")
		can_throw = true


func throw_spear() -> void:
	var start_position = self.global_position
	spear = spear_scene.instance()
	spear.global_position = self.global_position
	spear.look_at(get_global_mouse_position())
	var direction = (get_global_mouse_position() - start_position).normalized()
	spear.direction = direction
	connect("reload", spear, "_on_reload")
	get_parent().get_parent().add_child(spear)


func teletransport() -> void:
	var effect = teleport_effect.instance()
	effect.global_position = self.global_position
	get_parent().get_parent().add_child(effect)
	var player = get_parent()
	player.can_control = false
	player.position = spear.position
	emit_signal("reload")
	player.can_control = true
