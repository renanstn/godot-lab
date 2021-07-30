extends Area2D


export var rotation_velocity: float = 0.2
export var direction_path: NodePath
var direction: Area2D
onready var sprite = $Sprite


func _ready():
	pass # Replace with function body.


func _process(_delta):
	sprite.rotation += rotation_velocity
