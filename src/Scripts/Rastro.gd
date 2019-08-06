extends Node2D

func setup(origem : Vector2, destino : Vector2) -> void:
	$Line2D.add_point(origem)
	$Line2D.add_point(destino)

func _process(delta):
	# Fade no rastro até desaparecer
	var alpha = modulate.a
	alpha -= 0.1
	modulate = Color(modulate.r, modulate.g, modulate.b, alpha)
	if alpha < 0:
		queue_free()
