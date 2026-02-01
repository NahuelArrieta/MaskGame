extends Node2D

# Esta variable aparecerá en el Inspector de Godot
@export var tiempo_entre_gotas: float = 1.0
@export var gota_scene: PackedScene = preload("./water_drop.tscn")

@onready var timer = $Timer
@onready var marker = $Marker2D



func _ready():
	# Configuramos el timer con el valor que elegiste
	timer.wait_time = tiempo_entre_gotas
	timer.start()

func _on_timer_timeout():
	# Instanciamos la gota
	var gota = gota_scene.instantiate()
	# La posicionamos en el marcador
	gota.global_position = marker.global_position
	# La añadimos a la escena (mejor al nivel de la escena para que no se mueva con el caño)
	get_tree().current_scene.add_child(gota)
	
	# Por si cambiaste el valor en tiempo real desde el Inspector
	if timer.wait_time != tiempo_entre_gotas:
		timer.wait_time = tiempo_entre_gotas
