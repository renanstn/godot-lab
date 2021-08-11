extends Area2D


enum STATES {
	IDLE,
	GOING,
	RETURNING,
}

onready var sprite = $Sprite

export var rotation_speed: float = 0.3
export var max_speed: int
export var boomerang_range: int

var state = STATES.IDLE
var start_position: Vector2 = Vector2()
var target: Vector2
var parent: Node
var rotation_angle: int
var speed: int


func _ready():
	start_position = position
	speed = max_speed


func _process(delta):
	if state != STATES.IDLE:
		sprite.rotation += rotation_speed
	
	if state == STATES.GOING:
		var direction = (target - start_position).normalized()
		var distance_to_target = position.distance_to(target)
		if distance_to_target < 5:
			state = STATES.RETURNING
			target = parent.position
		elif distance_to_target < 100:
			speed -= 20
		position += direction.rotated(rotation) * speed * delta
	
	if state == STATES.RETURNING:
		var direction = (parent.position - position).normalized()
		var distance_to_player = position.distance_to(parent.position)
		speed += 20
		if distance_to_player < 10:
			queue_free()
		position += direction.rotated(rotation) * speed * delta
