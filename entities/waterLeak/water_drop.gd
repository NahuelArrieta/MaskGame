extends Node2D

var velocidad = 300


@onready var rayo = $RayCast2D

func _process(delta):
	if rayo.is_colliding():
		var collider = rayo.get_collider()
		if collider.has_method("touch_water"):
			collider.touch_water()
			queue_free()
		else:
			queue_free()
	else:
		position.y += velocidad * delta
