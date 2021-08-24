extends RigidBody2D


func _ready():
	$LifeTimer.start()


func _on_LifeTimer_timeout():
	queue_free()
