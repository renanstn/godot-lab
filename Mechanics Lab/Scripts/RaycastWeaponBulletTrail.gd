extends Node2D


onready var animation_player = $AnimationPlayer


func setup(origin: Vector2, destiny: Vector2) -> void:
	$Line2D.add_point(origin)
	$Line2D.add_point(destiny)


func _ready():
	animation_player.play("FadeOut")


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
