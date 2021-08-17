extends Area2D


onready var static_body = $StaticBody2D
onready var collision_shape = $StaticBody2D/CollisionShape2D

export var speed: int = 800
var direction: Vector2


func _process(delta):
	if direction:
		position += direction * speed * delta


func _on_Spear_body_entered(_body):
	direction = Vector2.ZERO
	collision_shape.call_deferred("set", "disabled", false)


func _on_reload():
	queue_free()
