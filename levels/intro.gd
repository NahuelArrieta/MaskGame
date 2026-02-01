extends Control

func _ready() -> void:
	$AudioStreamPlayer.play()
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://levels/Menu.tscn")
	pass # Replace with function body.
