extends Node2D

var lastCheckpoint: Area2D = null
@onready var player_scene = preload("res://entities/player/player.tscn")

func _ready() -> void:
	Global.checkpointReaced.connect(on_checpoint_reached)
	Global.die.connect(on_die)
	
func on_checpoint_reached(checkpoint):
	lastCheckpoint = checkpoint

func on_die():
	# 1. Definir la posición de aparición
	var spawn_pos = Vector2.ZERO
	
	if lastCheckpoint == null:
		get_tree().reload_current_scene()
		return
	else:
		spawn_pos = lastCheckpoint.get_node("Marker").global_position

	# 2. Borrar al jugador viejo
	if has_node("Player"):
		$Player.name = "Player_Old" # Cambiamos el nombre para que no choque
		$Player_Old.queue_free()

	# 3. Crear el nuevo
	var new_player = player_scene.instantiate()
	new_player.name = "Player" # Importante: ponerle el nombre exacto
	add_child(new_player)
	
	# 4. Posicionarlo exactamente como hacías tú
	new_player.global_position = spawn_pos
	
	
		
