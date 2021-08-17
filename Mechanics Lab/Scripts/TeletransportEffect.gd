extends Sprite


onready var tween  =$Tween


func _ready():
	tween.interpolate_property(
		self,
		"scale",
		scale,
		Vector2(0, 0), 
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
