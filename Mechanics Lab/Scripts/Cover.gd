extends StaticBody2D


func _on_CoverArea_body_entered(body):
	if body is KinematicBody2D:
		body.can_cover = true


func _on_CoverArea_body_exited(body):
	if body is KinematicBody2D:
		body.can_cover = false
