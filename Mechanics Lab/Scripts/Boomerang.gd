extends Area2D


enum STATES {
	IDLE,
	GOING,
	RETURNING,
}

onready var sprite = $Sprite

export var rotation_speed: float = 0.3
export var max_speed: int

var state = STATES.IDLE
var start_position: Vector2 = Vector2()
var target: Vector2
var parent: Node
var speed: int


func _ready():
	start_position = position
	speed = max_speed


func _process(delta):
	if state != STATES.IDLE:
		# Spin the sprite!
		sprite.rotation += rotation_speed
	
	if state == STATES.GOING:
		var direction = (target - start_position).normalized()
		var distance_to_target = position.distance_to(target)
		if distance_to_target < 5:
			state = STATES.RETURNING
			target = parent.position
		elif distance_to_target < 100:
			# Reduce speed before reach the target, to create a smooth effect
			speed -= 20
		# Move boomerang towards the target direction
		position += direction.rotated(rotation) * speed * delta
	
	if state == STATES.RETURNING:
		var direction = (parent.position - position).normalized()
		var distance_to_player = position.distance_to(parent.position)
		# Increase the speed gradativally
		speed += 20
		if distance_to_player < 10:
			# Destroy boomerang when it reach the player
			queue_free()
		# Move boomerang towards the player direction
		position += direction.rotated(rotation) * speed * delta
