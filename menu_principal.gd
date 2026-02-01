extends CanvasLayer
func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level-001.tscn")
	pass # Replace with function body.

func _on_boton_salir_pressed() -> void:
	# Esta es la instrucción mágica para cerrar la ventana del juego
	get_tree().quit()
