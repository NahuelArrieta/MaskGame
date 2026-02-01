extends Node2D

var velocidad = 300


@onready var rayo = $RayCast2D

func _process(delta):
	if rayo.is_colliding():
		queue_free()
	else:
		position.y += velocidad * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("touch_water"):
		body.touch_water()
