extends Camera2D

func _ready():
	position = Vector2(300, 0)
	# Fazer a conexão do signal emitido pelo Player
	get_parent().connect("player_flipped", self, "_on_player_flipped")

func _on_player_flipped(direcao)->void:
	# Correção para deixar a camera sempre
	# posicionada mais a frente do player
	if direcao == "right":
		position = Vector2(300, 0)
	if direcao == "left":
		position = Vector2(-300, 0)
