extends Camera2D


func _process(_delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= 10
	elif Input.is_action_pressed("ui_right"):
		position.x += 10
