extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		get_tree().change_scene_to_file("res://levels/final.tscn")
	pass # Replace with function body.
