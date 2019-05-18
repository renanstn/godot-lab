extends Node

func _physics_process(delta):
	if Input.is_action_pressed("slow_motion"):
		if Engine.time_scale > 0.1:
			Engine.time_scale -= 5*delta
		else:
			Engine.time_scale = 0.1
	else:
		if Engine.time_scale < 0.1:
			Engine.time_scale += 5*delta
		else:
			Engine.time_scale = 1