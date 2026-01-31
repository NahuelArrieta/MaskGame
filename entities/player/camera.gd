extends Camera2D

@export var tilemap_layer: TileMapLayer # Arrastrá tu TileMapLayer aquí en el inspector

func _ready():
	if tilemap_layer:
		setup_camera_limits()

func setup_camera_limits():
	# Obtenemos el área usada en coordenadas de tiles
	var map_rect = tilemap_layer.get_used_rect()
	# Obtenemos el tamaño de los tiles
	var cell_size = tilemap_layer.tile_set.tile_size
	
	# Calculamos los límites en píxeles
	limit_left = map_rect.position.x * cell_size.x
	limit_top = map_rect.position.y * cell_size.y
	limit_right = map_rect.end.x * cell_size.x
	limit_bottom = map_rect.end.y * cell_size.y
