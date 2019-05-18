extends Node

const MAX_ARRAY_SIZE = 240

export(NodePath) var path_player
onready var player = get_node(path_player)
var positions : Array = []
var rewinding : bool = false

func _physics_process(delta):

	if Input.is_action_pressed("rewind_time"):
		if positions.size() > 0:
#			player.can_control = false
			rewinding = true
			player.global_position = positions[positions.size() - 1]
			positions.pop_back()
	
	if Input.is_action_just_released("rewind_time"):
		player.can_control = true
		rewinding = false

	if not rewinding:
		positions.append(player.global_position)
		if positions.size() > MAX_ARRAY_SIZE:
			positions.remove(0)
