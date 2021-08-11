extends Position2D


export var boomerang_scene: PackedScene


func _process(_delta):
	if Input.is_action_just_pressed("mouse_left"):
		var boomerang = boomerang_scene.instance()
		boomerang.parent = get_parent()
		boomerang.state = boomerang.STATES.GOING
		boomerang.global_position = self.global_position
		boomerang.target = get_global_mouse_position()
		get_parent().get_parent().add_child(boomerang)
